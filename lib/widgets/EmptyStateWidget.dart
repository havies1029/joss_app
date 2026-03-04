import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
class EmptyStateWidget extends StatelessWidget {
  final String statusId; // contoh: "10001"

  const EmptyStateWidget({super.key, required this.statusId});

  static const Map<int, String> _statusSubtitleMap = {
    10001: "Polis yang sedang berlaku akan muncul di sini setelah pembelian berhasil.",
    10002: "Polis yang masih menunggu verifikasi atau penerbitan akan tampil di sini.",
    10003: "Polis yang sudah berakhir atau tidak diperpanjang akan muncul di sini.",
    10004: "Polis yang akan jatuh tempo dalam 60 hari ke depan akan muncul di sini.",
  };

  static const Map<int, String> _statusTitleMap = {
    10001: "Aktif",
    10002: "Diproses",
    10003: "Non Aktif",
    10004: "Jatuh Tempo",
  };

  @override
  Widget build(BuildContext context) {
    final int? id = int.tryParse(statusId);

    final title = _statusTitleMap[id] ?? "Status";
    final subtitle = _statusSubtitleMap[id] ??
        "Tidak ada data yang tersedia untuk kategori ini.";

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/no_data.svg",
              width: 70,
              height: 70,
              colorFilter: const ColorFilter.mode(
                Colors.white70,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: hPadding),

            Text(
              "Tidak ada polis $title",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryLightColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: sGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
