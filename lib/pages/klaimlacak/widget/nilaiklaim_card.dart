import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NilaiKlaimCard extends StatelessWidget {
  final String curr;
  final double klaimAmount;

  const NilaiKlaimCard({
    super.key,
    required this.curr,
    required this.klaimAmount,
  });

  String _formatIdWithSpace(double value) {
    // format id_ID default: 2.000.000.000,00
    final f = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',        // kita taruh "curr" sendiri
      decimalDigits: 2,
    );

    final s = f.format(value).trim();     // "2.000.000.000,00"
    return s.replaceAll('.', ' ');        // "2 000 000 000,00"
  }

  @override
  Widget build(BuildContext context) {
    final amountText = '${curr.trim()} ${_formatIdWithSpace(klaimAmount)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C2C2C),
            Color(0xFF3A3A3A),
          ],
        ),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nilai Klaim :',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amountText,
            style: const TextStyle(
              color: Color(0xFFF2C94C), // kuning seperti contoh
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
