import 'package:flutter/material.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';
import 'riwayat_table_header.dart';
import 'riwayat_table_row.dart';
import 'riwayat_table_style.dart';

class RiwayatTableCompact extends StatelessWidget {
  final List<HistorybayarCariModel> items;
  final ScrollController hController;
  final ValueChanged<HistorybayarCariModel> onTap;

  const RiwayatTableCompact({
    super.key,
    required this.items,
    required this.hController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tableWidth =
        RiwayatTableStyle.wNo +
        RiwayatTableStyle.wInv +
        RiwayatTableStyle.wTgl +
        RiwayatTableStyle.wJml +
        RiwayatTableStyle.wStatus +
        RiwayatTableStyle.wTotal;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: RiwayatTableStyle.boxDecoration(),
        child: Scrollbar(
          controller: hController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: hController,
            scrollDirection: Axis.horizontal,
            child: SizedBox( // ✅ width dibuat FIXED (bounded)
              width: tableWidth,
              child: Column(
                children: [
                  const RiwayatTableHeader(compact: true),
                  RiwayatTableStyle.divider,

                  // ✅ TANPA ListView (hindari viewport unbounded width)
                  for (int i = 0; i < items.length; i++) ...[
                    RiwayatTableRow(
                      item: items[i],
                      index: i,
                      compact: true,
                      onTap: () => onTap(items[i]),
                    ),
                    RiwayatTableStyle.divider,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}