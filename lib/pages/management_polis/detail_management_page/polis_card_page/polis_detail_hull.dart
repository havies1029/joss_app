import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PolisDetailHull extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const PolisDetailHull({
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

    // ===== ambil value sesuai header table =====
    String s(String key) {
      final v = dataMap[key]?.toString().trim();
      return (v == null || v.isEmpty) ? "-" : v;
    }

    final tertanggung = s("tertanggung");
    final namaKapal = s("namaKapal");
    final curr = s("curr");

    final tsi = _toNum(dataMap["tsi"]);
    final premi = _toNum(dataMap["premi"]);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Polis Hull")),
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
              /// title boleh tetap nama kapal biar enak
              Text(
                namaKapal,
                style: TextStyle(
                  fontSize: fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),

              /// ===== SESUAI HEADER TABLE =====
              _row("Tertanggung", tertanggung, labelColor, valueColor, fontSize, context),
              _row("Detail Rangka Kapal", namaKapal, labelColor, valueColor, fontSize, context),
              _row(
                "Nilai Tertanggung",
                _money(curr, tsi),
                labelColor,
                valueColor,
                fontSize,
                context,
              ),
              _row(
                "Premi",
                _money(curr, premi), // ✅ plus curr juga
                labelColor,
                valueColor,
                fontSize,
                context,
              ),
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

  static String _money(String curr, num v) {
    final n = NumberFormat.decimalPattern().format(v);
    if (curr.trim().isEmpty || curr == "-") return n;
    return "$curr $n";
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
              overflow: TextOverflow.ellipsis,
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
