import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransaksiListWidget extends StatefulWidget {
  const TransaksiListWidget({super.key});

  @override
  State<TransaksiListWidget> createState() => _TransaksiListWidgetState();
}

class _TransaksiListWidgetState extends State<TransaksiListWidget> {
  late TrslogCariBloc trslogCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    trslogCariBloc = BlocProvider.of<TrslogCariBloc>(context);
    // Ambil data awal (tanpa search)
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  void refreshData() {
    trslogCariBloc.add(
      RefreshTrslogCariEvent(searchText: _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      decoration: BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/transaksi.svg",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Transaksi',
                style: headingStyle(context).copyWith(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 13),
          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: bodyTextStyle(context),
                  decoration: InputDecoration(
                    hintText: "Cari transaksi...",
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (val) => refreshData(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: refreshData,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: refreshData,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // List transaksi
          BlocBuilder<TrslogCariBloc, TrslogCariState>(
            builder: (context, state) {
              if (state.status == ListStatus.initial) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Tidak ada transaksi.',
                    style: bodyTextStyle(context),
                  ),
                );
              }
              // Hanya tampilkan max 3 transaksi terbaru
              final items = state.items.take(3).toList();

              return Container(
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  border: Border.all(color: sGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(hPadding),
                      child: Text(
                        "Transaksi Terbaru",
                        style: bodyTextStyle(context, fontSize: 20),
                      ),
                    ),
                    kDivider(color: sGrey),
                    // List Item
                    ...items
                        .map((item) => _buildTransactionItem(context, item))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(hPadding),
                      child: AppButton.primary(
                        backgroundColor: sGrey,
                        text: "Lihat Semua Transaksi  ›",
                        onPressed: () {
                          // TODO: Arahkan ke halaman list transaksi penuh
                        },
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic item) {
    final iconAsset = _getIconAsset(item.jenis_trs);

    // Format tanggal
    String tgl = "-";
    if (item.trsTgl != null) {
      try {
        final tglDt =
            (item.trsTgl is String) ? DateTime.parse(item.trsTgl) : item.trsTgl;
        tgl = "${tglDt.day} ${_monthIndo(tglDt.month)} ${tglDt.year}";
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(hPadding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: sGrey, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconAsset, width: 40, height: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title: jenis_trs
                Text(
                  item.jenis_trs ?? "-",
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                // Subtitle: keterangan
                if (item.keterangan != null &&
                    item.keterangan.toString().trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      item.keterangan,
                      style: bodyTextStyle(
                        context,
                        fontSize: 16,
                      ).copyWith(color: hintGrey),
                    ),
                  ),
                // Date
                Text(
                  tgl,
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                ),
              ],
            ),
          ),
          // Amount & status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount: curr + nilaiTrs
              Text(
                "${item.curr ?? ''} ${item.nilaiTrs != null ? NumberFormat("#,###").format(item.nilaiTrs) : '-'}",
                style: bodyTextStyle(context),
              ),
              const SizedBox(height: 2),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status_nama),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.status_nama ?? "-",
                  style: bodyTextStyle(context, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getIconAsset(String? jenisTrs) {
    switch (jenisTrs?.toLowerCase()) {
      case 'pembayaran premi':
        return "assets/icons/pembayaran_premi.svg";
      case 'klaim asuransi':
        return "assets/icons/klaim_asuransi.svg";
      case 'penutupan asuransi':
        return "assets/icons/tagihan_pembayaran.svg";
      default:
        return "assets/icons/transaksi.svg";
    }
  }

  String _monthIndo(int month) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return bulan[month];
  }

  Color _getStatusColor(String? status) {
    if (status == null) return pGrey;
    switch (status.toLowerCase()) {
      case "berhasil":
      case "disetujui":
        return pGreen;
      case "ditolak":
        return pRed;
      case "diproses":
        return pBlue;
      default:
        return pGrey;
    }
  }
}
