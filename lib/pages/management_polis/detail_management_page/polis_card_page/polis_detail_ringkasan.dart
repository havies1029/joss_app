import 'package:flutter/material.dart';

class PolisDetailRingkasan extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const PolisDetailRingkasan({
    super.key,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = (BuildContext c, double base) => base;

    final labelColor = Colors.grey.shade600;
    final valueColor = Colors.black87;
    final dividerColor = Colors.grey.shade300;
    final borderColor = Colors.grey.shade300;
    final cardColor = Colors.white;

    // ambil header values
    final String asetNama = dataMap["asetNama"]?.toString() ?? "-";
    final String asetRingkasanId = dataMap["asetRingkasanId"]?.toString() ?? "-";
    final String curr = dataMap["curr"]?.toString() ?? "-";
    final int jmlAset = dataMap["jmlAset"] ?? 0;
    final double nilaiAset = (dataMap["nilaiAset"] ?? 0).toDouble();
    final double nilaiPremi = (dataMap["nilaiPremi"] ?? 0).toDouble();
    final int noUrut = dataMap["noUrut"] ?? 0;
    final String satuan = dataMap["satuan"]?.toString() ?? "-";

    // filter entries biar header gak dobel muncul
    final excludeKeys = {
      "asetNama",
      "asetRingkasanId",
      "curr",
      "jmlAset",
      "nilaiAset",
      "nilaiPremi",
      "noUrut",
      "satuan",
      "no"
    };

    final entries = dataMap.entries.where((e) {
      if (excludeKeys.contains(e.key)) return false;
      final value = e.value?.toString().trim() ?? "";
      if (value.isEmpty || value == "-" || value.toLowerCase() == "null") {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Ringkasan")),
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

              /// ===== HEADER RINGKASAN =====
              Text(
                asetNama,
                style: TextStyle(
                  fontSize: fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 12),

              _row("ID Ringkasan", asetRingkasanId, labelColor, valueColor, fontSize, context),
              _row("Jumlah Aset", "$jmlAset $satuan", labelColor, valueColor, fontSize, context),
              _row("Nilai Aset", "$curr $nilaiAset", labelColor, valueColor, fontSize, context),
              _row("Nilai Premi", "$curr $nilaiPremi", labelColor, valueColor, fontSize, context),

              Divider(color: dividerColor, height: 24),

              ...entries.map((entry) {
                final label = _beautifyKey(entry.key);
                final value = entry.value?.toString() ?? "-";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _row(label, value, labelColor, valueColor, fontSize, context),
                );
              }).toList(),
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
    return Row(
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
    );
  }

  String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
