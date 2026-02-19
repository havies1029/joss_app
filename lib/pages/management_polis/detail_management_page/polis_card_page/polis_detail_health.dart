import 'package:flutter/material.dart';

class PolisDetailHealth extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const PolisDetailHealth({
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

    // ===== SESUAI HEADER TABLE =====
    final nama = s("nama");
    final benefit = s("status"); // table: Benefit = status

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Polis Health")),
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
              /// title boleh tetap nama
              Text(
                nama,
                style: TextStyle(
                  fontSize: fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),

              _row("Nama", nama, labelColor, valueColor, fontSize, context),
              _row("Benefit", benefit, labelColor, valueColor, fontSize, context),
            ],
          ),
        ),
      ),
    );
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
