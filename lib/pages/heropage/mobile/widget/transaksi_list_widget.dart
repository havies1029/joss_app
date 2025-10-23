import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/heropage/mobile/widget/transaksi_page.dart';

class TransaksiListWidget extends StatefulWidget {
  const TransaksiListWidget({super.key});

  @override
  State<TransaksiListWidget> createState() => _TransaksiListWidgetState();
}

class _TransaksiListWidgetState extends State<TransaksiListWidget>
    with SingleTickerProviderStateMixin {
  late TrslogCariBloc trslogCariBloc;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 🔹 untuk auto scroll
  bool _isExpanded = false;

  // Buat key supaya bisa tahu posisi widget
  final _sectionKey = GlobalKey();

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

  void _scrollToSection() {
    // tunggu layout siap baru animasikan scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _sectionKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _sectionKey,
      padding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: vPadding,
      ),
      decoration: BoxDecoration(color: secondaryBlackColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header collapsible
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              if (_isExpanded) {
                Future.delayed(const Duration(milliseconds: 250), _scrollToSection);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/transaksi.svg",
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Transaksi',
                    style: headingStyle(context).copyWith(fontSize: 20),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0, // 180° rotasi
                  curve: Curves.easeInOut,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: primaryLightColor,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          _isExpanded? const SizedBox(height: vPadding * 0.5) : const SizedBox.shrink(),

          // 🔹 Animasi expand/collapse pakai kombinasi AnimatedSize + Opacity
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: _isExpanded ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? BlocBuilder<TrslogCariBloc, TrslogCariState>(
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
                      padding: const EdgeInsets.all(32),
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
                      borderRadius:
                      BorderRadius.circular(cardBorderRadius),
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
                            style:
                            bodyTextStyle(context, fontSize: 20),
                          ),
                        ),
                        kDivider(color: sGrey),

                        // List Item
                        ...items
                            .map(
                              (item) =>
                              _buildTransactionItem(context, item),
                        )
                            .toList(),

                        Padding(
                          padding: const EdgeInsets.all(hPadding),
                          child: AppButton.primary(
                            backgroundColor: formGrey,
                            text: "Lihat Semua Transaksi  ›",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    const TransaksiPage()),
                              );
                            },
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic item) {
    final iconAsset = _getIconAsset(item.jenis_trs);

    // Format tanggal
    String dateTimeStr = "-";
    if (item.trsTgl != null) {
      try {
        final tglDt =
        (item.trsTgl is String) ? DateTime.parse(item.trsTgl) : item.trsTgl;
        dateTimeStr = "${tglDt.day} ${_monthIndo(tglDt.month)} ${tglDt.year}";
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(hPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon dengan background
          SvgPicture.asset(iconAsset, width: 40, height: 40),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction type
                Text(
                  item.jenis_trs ?? "-",
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                const SizedBox(height: 4),

                // Date and time
                Text(
                  dateTimeStr,
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                ),
              ],
            ),
          ),

          // status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
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
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
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