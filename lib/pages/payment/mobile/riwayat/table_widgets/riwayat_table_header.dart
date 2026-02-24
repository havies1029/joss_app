import 'package:flutter/material.dart';
import 'riwayat_table_style.dart';

class RiwayatTableHeader extends StatelessWidget {
  final bool compact;
  const RiwayatTableHeader({super.key, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2B2B2B), // formGrey juga boleh, sesuaikan
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: compact ? _buildCompact() : _buildNormal(),
    );
  }

  Widget _buildCompact() {
    return Row(
      children: [
        RiwayatTableStyle.cellBox("NO", width: RiwayatTableStyle.wNo, center: true, fontWeight: FontWeight.w700),
        RiwayatTableStyle.cellBox("NO PEMBAYARAN", width: RiwayatTableStyle.wInv, fontWeight: FontWeight.w700),
        RiwayatTableStyle.cellBox("TANGGAL\nDIBAYAR", width: RiwayatTableStyle.wTgl, fontWeight: FontWeight.w700),
        RiwayatTableStyle.cellBox("JUMLAH\nPOLIS", width: RiwayatTableStyle.wJml, fontWeight: FontWeight.w700),
        RiwayatTableStyle.cellBox("STATUS", width: RiwayatTableStyle.wStatus, fontWeight: FontWeight.w700),
        RiwayatTableStyle.cellBox("TOTAL PEMBAYARAN", width: RiwayatTableStyle.wTotal, fontWeight: FontWeight.w700),
      ],
    );
  }

  Widget _buildNormal() {
    Widget exp(String text, int flex, {bool center = false}) {
      return Expanded(
        flex: flex,
        child: RiwayatTableStyle.cellBox(
          text,
          center: center,
          fontWeight: FontWeight.w700,
          width: null,
        ),
      );
    }

    return Row(
      children: [
        exp("NO", 1, center: true),
        exp("NO PEMBAYARAN", 3),
        exp("TANGGAL\nDIBAYAR", 2),
        exp("JUMLAH\nPOLIS", 2),
        exp("STATUS", 2),
        exp("TOTAL PEMBAYARAN", 3),
      ],
    );
  }
}