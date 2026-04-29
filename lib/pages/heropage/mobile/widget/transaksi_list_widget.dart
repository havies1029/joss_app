import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:joss_app/blocs/notiflog/logtrscaritopx_bloc.dart'; // ✅ ganti ke bloc baru
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/models/notiflog/logtrscari_model.dart';
import 'package:joss_app/pages/heropage/mobile/widget/transaksi_page.dart';
import 'package:intl/intl.dart';

class TransaksiListWidget extends StatefulWidget {
  const TransaksiListWidget({super.key});

  @override
  State<TransaksiListWidget> createState() => _TransaksiListWidgetState();
}

class _TransaksiListWidgetState extends State<TransaksiListWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final _sectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<LogtrscaritopxBloc>().add(RefreshLogtrscaritopxEvent());
    });
  }

  void _scrollToSection() {
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
          // Header collapsible
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
                    'Riwayat Transaksi',
                    style: headingStyle(context).copyWith(fontSize: 20),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0,
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

          _isExpanded
              ? const SizedBox(height: vPadding * 0.5)
              : const SizedBox.shrink(),

          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: _isExpanded ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? BlocBuilder<LogtrscaritopxBloc, LogtrscaritopxState>(
                builder: (context, state) {
                  if (state.status == ListStatus.initial && state.items.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: LoadingIndicator(),
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

                  // tampilkan max 3 (top 3)
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(hPadding),
                          child: Text(
                            "Riwayat Transaksi Terbaru",
                            style: bodyTextStyle(context, fontSize: 20),
                          ),
                        ),
                        kDivider(color: sGrey),

                        // List item
                        ...items
                            .map((item) => _buildLogItem(context, item)),

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
          // icon (boleh kamu mapping dari jenisLog kalau mau)
          _logIcon(item.jenisLog),
          const SizedBox(width: 16),

          // content
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
          SizedBox(
            width: 90,
            child: Text(
              item.status.isNotEmpty ? item.status : "-",
              textAlign: TextAlign.right,
              style: bodyTextStyle(context, fontSize: 16).copyWith(
                color: _getStatusColor(item.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
        return successGreen;
      case "ditolak":
        return pRed;
      case "diproses":
        return pBlue;
      default:
        return pGrey;
    }
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