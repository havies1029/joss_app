import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/asetothers/sppa2otherscari_model.dart';
import '../template_polis_table/detail_polis_table.dart';

class DetailPolisOthersTableWidget extends StatefulWidget {
  final List<Sppa2othersCariModel> items;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  const DetailPolisOthersTableWidget({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<DetailPolisOthersTableWidget> createState() =>
      _DetailPolisOthersTableWidgetState();
}

class _DetailPolisOthersTableWidgetState
    extends State<DetailPolisOthersTableWidget> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  // @override
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.of(context).size.width;
  //   final bool isNarrow = width < 900;
  //
  //   if (widget.items.isEmpty) {
  //     return _emptyState();
  //   }
  //
  //   return isNarrow ? _buildCompactTable() : _buildNormalTable();
  // }

  @override
  Widget build(BuildContext context) {
    return DetailPolisTable<Sppa2othersCariModel>(
      items: widget.items,
      onLoadMore: widget.onLoadMore,
      isLoadingMore: widget.isLoadingMore,
      emptyText: "Data polis tidak ditemukan.",
      columns: [
        DetailPolisColumn<Sppa2othersCariModel>(
          title: "INFO",
          valueGetter: (d) => d.info1.isNotEmpty ? d.info1 : "-",
          normalFlex: 2.4,
          compactMinWidth: 180,
          compactMaxWidth: 280,
        ),
        DetailPolisColumn<Sppa2othersCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${formatNum(d.tsi)}",
          normalFlex: 2.2,
          compactMinWidth: 170,
          compactMaxWidth: 240,
          right: true,
        ),
        DetailPolisColumn<Sppa2othersCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${formatNum(d.premiNet)}",
          normalFlex: 2.0,
          compactMinWidth: 150,
          compactMaxWidth: 220,
          right: true,
        ),
      ],
    );
  }
}