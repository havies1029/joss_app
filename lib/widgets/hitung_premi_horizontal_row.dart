import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/constants.dart';
import 'hitung_premi_widget.dart';

class HitungPremiHorizontalRow extends StatelessWidget {
  final HitungPremiRow row;

  const HitungPremiHorizontalRow({
    super.key,
    required this.row,
  });

  Widget _buildValue(TextStyle? valueStyle, String displayValue) {
    final valueText = Text(
      displayValue,
      style: valueStyle,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
    );

    if (!row.showValueBorder) return valueText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: valueText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = row.labelStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: getResponsiveFont(context, 18),
          color: hintGrey,
        );

    final baseValueStyle = row.valueStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: getResponsiveFont(context, 18),
          color: primaryLightColor,
        );

    final valueStyle = row.highlight
        ? baseValueStyle?.copyWith(fontWeight: FontWeight.w700)
        : baseValueStyle;

    String cleanNum(num value) {
      final f = NumberFormat("#,###", "en_US");
      return f.format(value);
    }

    String formatControllerNumber(TextEditingController c) {
      if (c.text.isEmpty) return '';
      final value = num.tryParse(c.text.replaceAll(',', ''));
      if (value == null) return c.text;
      return cleanNum(value);
    }

    String buildDisplayValue(HitungPremiRow row) {
      final prefix = (row.valuePrefix ?? '').trim();
      final suffix = (row.valueSuffix ?? '').trim();

      final value = row.formatNumber
          ? formatControllerNumber(row.controller).trim()
          : row.controller.text.trim();

      final parts = <String>[];
      if (prefix.isNotEmpty) parts.add(prefix);
      if (value.isNotEmpty) parts.add(value);
      if (suffix.isNotEmpty) parts.add(suffix);

      return parts.join(' ');
    }
    final displayValue = buildDisplayValue(row);

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            row.label,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
          _buildValue(valueStyle, displayValue),
        ],
      ),
    );
  }
}
