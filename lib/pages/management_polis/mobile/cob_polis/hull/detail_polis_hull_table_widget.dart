import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/gen_aset_hull/sppa2hullcari_model.dart';
import '../template_polis_table/detail_polis_table.dart';

class DetailPolisHullTableWidget extends StatefulWidget {
  final List<Sppa2hullCariModel> items;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  const DetailPolisHullTableWidget({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<DetailPolisHullTableWidget> createState() =>
      _DetailPolisHullTableWidgetState();
}

class _DetailPolisHullTableWidgetState
    extends State<DetailPolisHullTableWidget> {
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
    return DetailPolisTable<Sppa2hullCariModel>(
      items: widget.items,
      onLoadMore: widget.onLoadMore,
      isLoadingMore: widget.isLoadingMore,
      emptyText: "Data polis tidak ditemukan.",
      columns: [
        DetailPolisColumn<Sppa2hullCariModel>(
          title: "NAMA KAPAL",
          valueGetter: (d) => d.namaKapal.isNotEmpty ? d.namaKapal : "-",
          normalFlex: 2.2,
          compactMinWidth: 160,
          compactMaxWidth: 260,
        ),
        DetailPolisColumn<Sppa2hullCariModel>(
          title: "KELAS KAPAL",
          valueGetter: (d) => d.vesselClass.isNotEmpty ? d.vesselClass : "-",
          normalFlex: 2.0,
          compactMinWidth: 150,
          compactMaxWidth: 240,
        ),
        DetailPolisColumn<Sppa2hullCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${formatNum(d.si)}",
          normalFlex: 1.7,
          compactMinWidth: 150,
          compactMaxWidth: 210,
        ),
        DetailPolisColumn<Sppa2hullCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${formatNum(d.premiNet)}",
          normalFlex: 1.5,
          compactMinWidth: 120,
          compactMaxWidth: 180,
        ),
      ],
    );
  }
}