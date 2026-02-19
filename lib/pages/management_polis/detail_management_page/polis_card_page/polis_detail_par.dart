import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PolisDetailPar extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const PolisDetailPar({
    super.key,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = (BuildContext c, double base) => base;

    final labelColor = Colors.grey.shade600;
    final valueColor = Colors.black87;
    final borderColor = Colors.grey.shade300;
    final cardColor = Colors.white;

    final dateFormat = DateFormat("dd MMM yyyy");

    // ===== AMBIL VALUE SESUAI KOLOM TABLE =====
    final prosesId = dataMap["prosesId"]?.toString().trim();
    final polisNo = dataMap["polisNo"]?.toString() ?? "-";
    final tertanggung = dataMap["tertanggung"]?.toString() ?? "-";
    final alamat = dataMap["alamat"]?.toString() ?? "-";
    final curr = dataMap["curr"]?.toString() ?? "-";

    final premi = _toNum(dataMap["premi"]);
    final sumInsured = _toNum(dataMap["sumInsured"]);

    final periodeMulai = _formatDate(dataMap["periodeMulai"], dateFormat);
    final periodeAkhir = _formatDate(dataMap["periodeAkhir"], dateFormat);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Polis PAR")),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // kalau mau title tetap tertanggung (opsional)
              Text(
                tertanggung,
                style: TextStyle(
                  fontSize: fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),

              _row("No Proses", (prosesId == null || prosesId.isEmpty) ? "-" : prosesId,
                  labelColor, valueColor, fontSize, context),
              _row("No Polis", polisNo, labelColor, valueColor, fontSize, context),
              _row("Tertanggung", tertanggung, labelColor, valueColor, fontSize, context),
              _row("Alamat", alamat, labelColor, valueColor, fontSize, context),
              _row("Periode", "$periodeMulai - $periodeAkhir", labelColor, valueColor, fontSize, context),
              _row("Nilai Pertanggungan", "$curr ${_formatNum(sumInsured)}",
                  labelColor, valueColor, fontSize, context),
              _row("Premi", "$curr ${_formatNum(premi)}",
                  labelColor, valueColor, fontSize, context),
            ],
          ),
        ),
      ),
    );
  }

  static num _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    final s = v.toString().replaceAll(',', '').trim();
    return num.tryParse(s) ?? 0;
  }

  static String _formatNum(num v) => NumberFormat.decimalPattern().format(v);

  String _formatDate(dynamic value, DateFormat format) {
    if (value == null) return "-";
    if (value is DateTime) return format.format(value);
    return value.toString();
  }

  Widget _row(
      String label,
      String value,
      Color labelColor,
      Color valueColor,
      double Function(BuildContext, double) fontSize,
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(color: labelColor, fontSize: fontSize(context, 16)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(color: valueColor, fontSize: fontSize(context, 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
