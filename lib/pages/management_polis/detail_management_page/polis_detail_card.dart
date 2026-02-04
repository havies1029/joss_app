import 'package:flutter/material.dart';

class PolisDetailCard extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  final String? title;
  final Set<String> excludeKeys;
  final Color cardColor;
  final Color borderColor;
  final Color dividerColor;
  final Color labelColor;
  final Color valueColor;
  final double borderRadius;

  final double Function(BuildContext context, double base) fontSize;

  const PolisDetailCard({
    super.key,
    required this.dataMap,
    this.title,
    this.excludeKeys = const {},
    required this.cardColor,
    required this.borderColor,
    required this.dividerColor,
    required this.labelColor,
    required this.valueColor,
    required this.borderRadius,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final entries = dataMap.entries
        .where((e) {
      if (excludeKeys.contains(e.key)) return false;

      final value = e.value?.toString().trim() ?? "";

      // jangan tampilkan kalau kosong, "-", atau "null"
      if (value.isEmpty || value == "-" || value.toLowerCase() == "null") {
        return false;
      }

      return true;
    })
        .toList();


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                color: valueColor,
                fontSize: fontSize(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Nomor urut (tetap)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "No:",
                style: TextStyle(
                  color: labelColor,
                  fontSize: fontSize(context, 16),
                ),
              ),
              Text(
                dataMap["no"]?.toString() ?? "1",
                style: TextStyle(
                  color: valueColor,
                  fontSize: fontSize(context, 16),
                ),
              ),
            ],
          ),

          Divider(color: dividerColor, height: 20),

          ...entries.map((entry) {
            final label = _beautifyKey(entry.key);
            final value = entry.value?.toString() ?? "-";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "$label:",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: fontSize(context, 16),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: valueColor,
                          fontSize: fontSize(context, 16),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty
        ? ''
        : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
