import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_par/sppa2parcari_model.dart';
import '../template_polis_table/detail_polis_table.dart';

class DetailPolisParTableWidget extends StatefulWidget {
  final List<Sppa2parCariModel> items;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  const DetailPolisParTableWidget({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<DetailPolisParTableWidget> createState() =>
      _DetailPolisParTableWidgetState();
}

class _DetailPolisParTableWidgetState
    extends State<DetailPolisParTableWidget> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  @override
  Widget build(BuildContext context) {
    return DetailPolisTable<Sppa2parCariModel>(
      items: widget.items,
      onLoadMore: widget.onLoadMore,
      isLoadingMore: widget.isLoadingMore,
      emptyText: 'Data polis tidak ditemukan.',
      columns: [
        DetailPolisColumn<Sppa2parCariModel>(
          title: 'LOKASI',
          valueGetter: (d) => d.lokasi1.isNotEmpty ? d.lokasi1 : '-',
          normalFlex: 2.2,
          compactMinWidth: 150,
          compactMaxWidth: 240,
        ),
        DetailPolisColumn<Sppa2parCariModel>(
          title: 'NILAI PERTANGGUNGAN',
          valueGetter: (d) => '${d.curr} ${formatNum(d.tsiTotal)}',
          normalFlex: 1.8,
          compactMinWidth: 135,
          compactMaxWidth: 180,
        ),
        DetailPolisColumn<Sppa2parCariModel>(
          title: 'PREMI',
          valueGetter: (d) => '${d.curr} ${formatNum(d.premiNet)}',
          normalFlex: 1.5,
          compactMinWidth: 115,
          compactMaxWidth: 160,
        ),
        DetailPolisColumn<Sppa2parCariModel>(
          title: 'DESKRIPSI',
          valueGetter: (d) =>
          d.okupasiDesc.isNotEmpty ? d.okupasiDesc : '-',
          normalFlex: 2.4,
          compactMinWidth: 160,
          compactMaxWidth: 260,
          expandable: true,
        ),
      ],
    );
  }

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
}