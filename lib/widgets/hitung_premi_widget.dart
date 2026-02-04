import 'package:flutter/material.dart';
import '../common/constants.dart';
import 'hitung_premi_horizontal_row.dart';
import 'hitung_premi_vertical_row.dart';

enum HitungPremiLayoutType { horizontal, vertical }

class HitungPremiRow {
  final String label;
  final String? description;
  final TextEditingController controller;
  final HitungPremiLayoutType layoutType;
  final bool highlight;
  final bool showValueBorder;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? descriptionStyle;
  final String? valuePrefix;
  final String? valueSuffix;
  final bool formatNumber;

  const HitungPremiRow({
    required this.label,
    this.description,
    required this.controller,
    this.layoutType = HitungPremiLayoutType.horizontal,
    this.highlight = false,
    this.showValueBorder = false,
    this.labelStyle,
    this.valueStyle,
    this.descriptionStyle,
    this.valuePrefix,
    this.valueSuffix,
    this.formatNumber = false,
  });
}

class HitungPremiWidget extends StatelessWidget {
  final List<HitungPremiRow> rows;

  /// padding dalam card
  final EdgeInsetsGeometry padding;

  /// jarak antar row
  final double rowSpacing;

  const HitungPremiWidget({
    super.key,
    required this.rows,
    this.padding = const EdgeInsets.all(0),
    this.rowSpacing = 0,
  });


  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _buildRow(context, rows[i]),
            if (rows[i].layoutType == HitungPremiLayoutType.vertical &&
                i != rows.length - 1) ...[
              const SizedBox(height: 2),
              const Divider(
                thickness: 1,
                color: sGrey,
              ),
              const SizedBox(height: 2),
            ] else if (i != rows.length - 1) ...[
              SizedBox(height: rowSpacing),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, HitungPremiRow row) {
    switch (row.layoutType) {
      case HitungPremiLayoutType.vertical:
        return HitungPremiVerticalRow(row: row);
      case HitungPremiLayoutType.horizontal:
      default:
        return HitungPremiHorizontalRow(row: row);
    }
  }
}
