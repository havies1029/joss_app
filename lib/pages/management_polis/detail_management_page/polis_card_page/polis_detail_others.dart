import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PolisDetailOthers extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const PolisDetailOthers({
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

    String s(String key) {
      final v = dataMap[key]?.toString().trim();
      return (v == null || v.isEmpty) ? "-" : v;
    }

    final objectDesc = s("objectDesc");
    final polisNo = s("polisNo");
    final curr = s("curr");

    final premi = _toNum(dataMap["premi"]);
    final sumInsured = _toNum(dataMap["sumInsured"]);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Polis")),
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
              /// ===== HEADER / TITLE =====
              Text(
                objectDesc,
                style: TextStyle(
                  fontSize: fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),

              /// ===== SESUAI HEADER TABLE: Object, Polis No, Sum Insured, Premi =====
              _row("Object", objectDesc, labelColor, valueColor, fontSize, context),
              _row("Polis No", polisNo, labelColor, valueColor, fontSize, context),
              _row(
                "Sum Insured",
                _money(curr, sumInsured),
                labelColor,
                valueColor,
                fontSize,
                context,
              ),
              _row(
                "Premi",
                _money(curr, premi),
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
