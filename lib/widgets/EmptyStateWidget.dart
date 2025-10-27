import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String statusLabel; // contoh: "Aktif", "Non Aktif", "Diproses", "Jatuh Tempo"

  const EmptyStateWidget({super.key, required this.statusLabel});

  String _getSubtitle(String label) {
    final lower = label.toLowerCase();
    if (lower.contains("aktif") && !lower.contains("non")) {
      return "Polis yang sedang berlaku akan muncul di sini setelah pembelian berhasil.";
    } else if (lower.contains("non")) {
      return "Polis yang sudah berakhir atau tidak diperpanjang akan muncul di sini.";
    } else if (lower.contains("proses")) {
      return "Polis yang masih menunggu verifikasi atau penerbitan akan tampil di sini.";
    } else if (lower.contains("jatuh")) {
      return "Polis yang akan jatuh tempo dalam 60 hari ke depan akan muncul di sini.";
    }
    return "Tidak ada data yang tersedia untuk kategori ini.";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Icon SVG
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

            // 🔹 Judul utama
            Text(
              "Tidak ada polis $statusLabel",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryLightColor,
                fontSize:16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // 🔹 Keterangan tambahan
            Text(
              _getSubtitle(statusLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
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
