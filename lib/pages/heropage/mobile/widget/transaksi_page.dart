import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

import '../../../../blocs/notiflog/logtrscari_bloc.dart';
import '../../../../models/notiflog/logtrscari_model.dart';

enum LogFilter { semua, aktivitas, transaksi }

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  LogFilter _filter = LogFilter.semua;
  final ScrollController _scrollController = ScrollController();

  String get _groupLogId {
    switch (_filter) {
      case LogFilter.semua:
        return "";
      case LogFilter.aktivitas:
        return "10";
      case LogFilter.transaksi:
        return "20";
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }


  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final bloc = context.read<LogtrscariBloc>();
    final state = bloc.state;
    if (state.hasReachedMax || state.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= (maxScroll - 200)) {
      bloc.add(FetchLogtrscariEvent());
    }
  }

  void _loadData() {
    context.read<LogtrscariBloc>().add(
      RefreshLogtrscariEvent(groupLogId: _groupLogId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Semua Transaksi",
      child: Container(
        color: secondaryBlackColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: hPadding),

            // Filter chips
            Container(
              margin: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip("Semua", LogFilter.semua),
                    const SizedBox(width: 8),
                    _buildFilterChip("Aktivitas", LogFilter.aktivitas),
                    const SizedBox(width: 8),
                    _buildFilterChip("Transaksi", LogFilter.transaksi),
                  ],
                ),
              ),
            ),

            const SizedBox(height: hPadding),

            // List
            Expanded(
              child: BlocBuilder<LogtrscariBloc, LogtrscariState>(
                builder: (context, state) {
                  if (state.status == ListStatus.initial) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: LoadingIndicator(),
                      ),
                    );
                  }

                  if (state.status == ListStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: hintGrey),
                            const SizedBox(height: 16),
                            Text(
                              "Gagal memuat data",
                              style: bodyTextStyle(context, fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Periksa koneksi internet Anda",
                              style: bodyTextStyle(context).copyWith(color: hintGrey),
                            ),
                            const SizedBox(height: 16),
                            AppButton.primary(
                              text: "Coba Lagi",
                              onPressed: _loadData,
                              backgroundColor: pBlue,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final items = state.items; // <- sumber data tunggal dari bloc

                  if (items.isEmpty) {
                    return _centerContainer(context);
                  }

                  // grouping sekali aja (jangan panggil berulang)
                  final groups = _groupByBulan(items);

                  return RefreshIndicator(
                    onRefresh: () async => _loadData(),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: groups.length,
                      itemBuilder: (context, groupIndex) {
                        final group = groups[groupIndex];
                        final month = group['month'] as String;
                        final groupItems = group['items'] as List<LogtrscariModel>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Month Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: hPadding * 1.5,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    month,
                                    style: bodyTextStyle(context, fontSize: 16),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${groupItems.length} Transaksi",
                                    style: bodyTextStyle(context, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),

                            // Card
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
                              decoration: BoxDecoration(
                                color: pGrey,
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                                border: Border.all(color: sGrey),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: groupItems.length,
                                separatorBuilder: (_, __) => kDivider(color: sGrey),
                                itemBuilder: (context, index) {
                                  final item = groupItems[index];
                                  return _buildLogItem(context, item);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, LogFilter value) {
    return ChoiceChip(
      label: Text(label, style: bodyTextStyle(context, fontSize: 16)),
      selected: _filter == value,
      onSelected: (_) {
        setState(() => _filter = value);
        _loadData(); // reload dengan groupLogId baru
      },
      selectedColor: primaryColor,
      backgroundColor: pGrey,
      showCheckmark: false,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  Widget _buildLogItem(BuildContext context, LogtrscariModel item) {
    String formatTanggalWaktu(dynamic value) {
      if (value == null) return "-";

      DateTime dt;
      if (value is DateTime) {
        dt = value;
      } else {
        final s = value.toString().replaceFirst(' ', 'T');
        dt = DateTime.tryParse(s) ?? DateTime.now();
      }

      return DateFormat("d MMM yyyy · HH:mm").format(dt);
    }

    final dateStr = formatTanggalWaktu(item.tglDibuat);
    return Container(
      padding: const EdgeInsets.all(hPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _logIcon(item.jenisLog),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.jenisLog.isNotEmpty ? item.jenisLog : "-",
                  style: bodyTextStyle(context, fontSize: 18)
                      .copyWith(color: primaryLightColor),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: bodyTextStyle(context, fontSize: 16)
                      .copyWith(color: hintGrey),
                ),
                // if (item.keterangan.isNotEmpty) ...[
                //   const SizedBox(height: 4),
                //   Text(
                //     item.keterangan,
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //     style: bodyTextStyle(context, fontSize: 14)
                //         .copyWith(color: hintGrey),
                //   ),
                // ],
              ],
            ),
          ),

          _buildRightSide(item),
        ],
      ),
    );
  }

  Widget _buildRightSide(LogtrscariModel item) {
    final isTransaksi = item.groupLogId == "20"; // <- patokan transaksi

    if (isTransaksi) {
      final amountText = _formatAmountNoSpace(item.curr, item.amount1);
      final remarkText = (item.remark1).isNotEmpty ? item.remark1 : "";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amountText,
            textAlign: TextAlign.right,
            style: bodyTextStyle(context, fontSize: 18).copyWith(
              color: successGreen, // hijau seperti contoh
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            remarkText.isNotEmpty ? remarkText : "-",
            textAlign: TextAlign.right,
            style: bodyTextStyle(context, fontSize: 16).copyWith(
              color: primaryLightColor, // putih
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    // selain transaksi: tampilkan status seperti biasa
    return SizedBox(
      width: 90,
      child: Text(
        item.status.isNotEmpty ? item.status : "-",
        textAlign: TextAlign.right,
        style: bodyTextStyle(context, fontSize: 16).copyWith(
          color: _getStatusColor(item.status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatAmountNoSpace(String curr, double amount) {
    final c = curr.isNotEmpty ? curr : "IDR";
    final nf = NumberFormat("#,##0", "id_ID");
    final amt = nf.format(amount);
    return "$c$amt";
  }

  List<Map<String, dynamic>> _groupByBulan(List<LogtrscariModel> items) {
    final Map<String, List<LogtrscariModel>> grouped = {};

    for (final item in items) {
      final key = item.groupBulan.isNotEmpty ? item.groupBulan : "Tanpa Bulan";
      (grouped[key] ??= []).add(item);
    }

    // Optional: sort item di tiap group by tglDibuat desc
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        final ad = a.tglDibuat;
        final bd = b.tglDibuat;
        if (ad == null && bd == null) return 0;
        return bd.compareTo(ad);
      });
    }

    // Kalau groupBulan kamu sudah terformat dan ingin urutan terbaru, idealnya backend sudah urut.
    // Kalau mau sort di sini juga, kita coba parse "MMMM yyyy" (id_ID) — tapi kalau formatnya beda, biarin urutan natural.
    final keys = grouped.keys.toList();

    return keys.map((k) => {'month': k, 'items': grouped[k]!}).toList();
  }

  String _getIconAsset(String? jenisLog) {
    final v = (jenisLog ?? "").toLowerCase();
    if (v.contains("pembayaran")) return "assets/icons/pembayaran_premi.svg";
    if (v.contains("klaim")) return "assets/icons/klaim_asuransi.svg";
    if (v.contains("penutupan")) return "assets/icons/tagihan_pembayaran.svg";
    return "assets/icons/transaksi.svg";
  }

  String _formatNumber(double v) {
    // simple format, bisa kamu sesuaikan
    final nf = NumberFormat("#,##0.##", "id_ID");
    return nf.format(v);
  }

  Color _getStatusColor(String? status) {
    if (status == null) return pGrey;
    switch (status.toLowerCase()) {
      case "berhasil":
      case "disetujui":
        return successGreen;
      case "ditolak":
        return pRed;
      case "diproses":
        return pBlue;
      default:
        return pGrey;
    }
  }

  ({String icon, String header, String desc}) _emptyStateByFilter() {
    switch (_filter) {
      case LogFilter.aktivitas:
        return (
        icon: "assets/icons/aktifitas_notifikasi.svg",
        header: "Tidak Ada Aktivitas",
        desc: "Saat ini Anda belum membuat Aktivitas apa pun",
        );
      case LogFilter.transaksi:
        return (
        icon: "assets/icons/transaksi_notifikasi.svg",
        header: "Tidak ada Transaksi",
        desc: "Saat ini Anda belum membuat Transaksi apa pun",
        );
      case LogFilter.semua:
        return (
        icon: "assets/icons/semua_notifikasi.svg",
        header: "Tidak ada Riwayat Transaksi",
        desc: "Saat ini Anda belum membuat Aktivitas Transaksi apa pun",
        );
    }
  }

  Widget _centerContainer(BuildContext context) {
    final e = _emptyStateByFilter();

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(e.icon, height: 50),
            const SizedBox(height: 20),

            Text(
              e.header,
              style: TextStyle(
                fontSize: getResponsiveFont(context, 16),
                color: primaryLightColor,
              ),
            ),
            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                e.desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 14),
                  color: hintGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logIcon(String? jenisLog) {
    final j = (jenisLog ?? "").toLowerCase().trim();

    String asset = "assets/icons/transaksi.svg"; // default fallback

    if (j.contains("klaim baru")) {
      asset = "assets/icons/KlaimBaru.svg";
    } else if (j.contains("pembatalan")) asset = "assets/icons/BatalKlaim.svg";
    else if (j.contains("update")) asset = "assets/icons/PerbaruiKlaim.svg";
    else if (j.contains("lapor")) asset = "assets/icons/LaporKlaim.svg";
    else if (j.contains("endorse")) asset = "assets/icons/EndorseLog.svg";
    else if (j.contains("perpanjang polis")) asset = "assets/icons/PerpanjanganLog.svg";
    else if (j.contains("aktivasi kembali")) asset = "assets/icons/AktifKembali.svg";
    else if (j.contains("beli polis")) asset = "assets/icons/RegOthers.svg";
    return SvgPicture.asset(
      asset,
      width: 40,
      height: 40,
    );
  }
}