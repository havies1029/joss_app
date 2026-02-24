import 'package:flutter/material.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';
import 'riwayat_table_header.dart';
import 'riwayat_table_row.dart';
import 'riwayat_table_style.dart';

class RiwayatTableNormal extends StatelessWidget {
  final List<HistorybayarCariModel> items;
  final ValueChanged<HistorybayarCariModel> onTap;

  const RiwayatTableNormal({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: RiwayatTableStyle.boxDecoration(),
        child: Column(
          children: [
            const RiwayatTableHeader(compact: false),
            RiwayatTableStyle.divider,
            for (int i = 0; i < items.length; i++) ...[
              RiwayatTableRow(
                item: items[i],
                index: i,
                compact: false,
                onTap: () => onTap(items[i]),
              ),
              RiwayatTableStyle.divider,
            ],
          ],
        ),
      ),
    );
  }
}