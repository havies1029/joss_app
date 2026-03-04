import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';

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
      symbol: '',
      decimalDigits: 2,
    );

    final s = f.format(value).trim();     // "2.000.000.000,00"
    return s.replaceAll('.', ' ');        // "2 000 000 000,00"
  }

  @override
  Widget build(BuildContext context) {
    final amountText = '${curr.trim()} ${_formatIdWithSpace(klaimAmount)}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),

        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF8F7715),
            pGrey,
          ],
          stops: [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 6),
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Nilai Klaim :',
              style: bodyTextStyle(context, fontSize: 14)
          ),
          Text(
              amountText,
              style: bodyTextStyle(context, fontSize: 14).copyWith(color: pYellow)

          ),
        ],
      ),
    );
  }
}
