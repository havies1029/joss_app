import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';
import 'riwayat_table_style.dart';
import 'package:joss_app/common/constants.dart';

class RiwayatTableRow extends StatelessWidget {
  final HistorybayarCariModel item;
  final int index;
  final bool compact;
  final VoidCallback onTap;

  const RiwayatTableRow({
    super.key,
    required this.item,
    required this.index,
    required this.compact,
    required this.onTap,
  });

  String _formatNum(num value) => NumberFormat.decimalPattern().format(value);
  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  Widget build(BuildContext context) {
    final bg = index.isEven ? pGrey : formGrey;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: bg,
        child: compact ? _buildCompact() : _buildNormal(),
      ),
    );
  }

  Widget _buildCompact() {
    return Row(
      children: [
        RiwayatTableStyle.cellBox((index + 1).toString(), width: RiwayatTableStyle.wNo, center: true),
        RiwayatTableStyle.cellBox(item.inv1Id, width: RiwayatTableStyle.wInv),
        RiwayatTableStyle.cellBox(_formatDate(item.invTgl), width: RiwayatTableStyle.wTgl),
        RiwayatTableStyle.cellBox(item.jmlPolis.toString(), width: RiwayatTableStyle.wJml),
        RiwayatTableStyle.cellBox(item.status.toString(), width: RiwayatTableStyle.wStatus),
        RiwayatTableStyle.cellBox(_formatNum(item.totalBayar), width: RiwayatTableStyle.wTotal),
      ],
    );
  }

  Widget _buildNormal() {
    Widget exp(Widget child, int flex) => Expanded(flex: flex, child: child);

    return Row(
      children: [
        exp(RiwayatTableStyle.cellBox((index + 1).toString(), center: true), 1),
        exp(RiwayatTableStyle.cellBox(item.inv1Id), 3),
        exp(RiwayatTableStyle.cellBox(_formatDate(item.invTgl)), 2),
        exp(RiwayatTableStyle.cellBox(item.jmlPolis.toString()), 2),
        exp(RiwayatTableStyle.cellBox(item.status.toString()), 2),
        exp(RiwayatTableStyle.cellBox(_formatNum(item.totalBayar)), 3),
      ],
    );
  }
}