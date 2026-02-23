import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogtrscariTileWidget extends StatelessWidget {
  final String jenisLog;
  final String status;
  final DateTime tglDibuat;
  final String groupBulan;
  final double amount1;
  final String curr;
  final String remark1;
  final String groupLogId; // "10" / "20" (string)

  const LogtrscariTileWidget({
    super.key,
    required this.jenisLog,
    required this.status,
    required this.tglDibuat,
    required this.groupBulan,
    required this.amount1,
    required this.curr,
    required this.remark1,
    required this.groupLogId,
  });

  static const _cardBg = Color(0xFF2C2C2C);
  static const _cardStroke = Color(0xFF3A3A3A);
  static const _iconCircle = Color(0xFF3A3A3A);
  static const _orange = Color(0xFFFF7A18);
  static const _green = Color(0xFF3FD06B);

  bool get _isAktivitas => groupLogId.toString().trim() == "10";
  bool get _isTransaksi => groupLogId.toString().trim() == "20";

  @override
  Widget build(BuildContext context) {

    final dt = DateFormat("d MMM yyyy · HH:mm").format(tglDibuat);

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardStroke, width: 1),
      ),
      child: Column(
        children: [
          _rowItem(
            context,
            title: jenisLog,
            subtitle: dt,
            trailing: _buildTrailing(),
            icon: _buildLeadingIcon(jenisLog),
          ),
        ],
      ),
    );
  }

  Widget _rowItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget trailing,
    required Widget icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),

          // middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 13,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // right
          trailing,
        ],
      ),
    );
  }

  Widget _buildTrailing() {
    if (_isAktivitas) {
      // gambar aktivitas: status di kanan (Berhasil)
      return Text(
        status,
        style: const TextStyle(
          color: _green,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      );
    }

    if (_isTransaksi) {
      // gambar transaksi: amount hijau + remark1 kecil (BCA VA)
      final amountText = _formatMoney(amount1, curr);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amountText,
            style: const TextStyle(
              color: _green,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            remark1,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    // default fallback
    return const SizedBox.shrink();
    }

  String _formatMoney(double value, String curr) {
    // contoh output: IDR9.119.000.000 (tanpa spasi, seperti gambar)
    // kamu bisa ubah format kalau mau ada spasi: "IDR 9.119.000.000"
    final nf = NumberFormat("#,##0", "id_ID");
    final numStr = nf.format(value).replaceAll(",", "."); // safety
    final c = (curr.isEmpty ? "" : curr.trim());
    return "$c$numStr";
  }

  Widget _buildLeadingIcon(String jenis) {
    final iconData = _iconFromJenis(jenis);

    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: _iconCircle,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: _orange,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  IconData _iconFromJenis(String jenis) {
    final j = jenis.toLowerCase().trim();

    if (j.contains("klaim baru")) return Icons.add;
    if (j.contains("pembatalan")) return Icons.close;

    if (j.contains("update")) return Icons.refresh;
    if (j.contains("lapor")) return Icons.arrow_upward;
    if (j.contains("endorse")) return Icons.edit;

    if (j.contains("perpanjang")) return Icons.refresh;
    if (j.contains("aktivasi kembali")) return Icons.refresh;

    if (j.contains("beli polis")) return Icons.shopping_cart_outlined;

    return Icons.notifications_none_rounded;
  }
}
