import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/gen_aset_health/sppa2healthcari_model.dart';
import '../template_polis_table/detail_polis_table.dart';

class DetailPolisHealthTableWidget extends StatefulWidget {
  final List<Sppa2healthCariModel> items;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  const DetailPolisHealthTableWidget({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<DetailPolisHealthTableWidget> createState() =>
      _DetailPolisHealthTableWidgetState();
}

class _DetailPolisHealthTableWidgetState
    extends State<DetailPolisHealthTableWidget> {

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
    return DetailPolisTable<Sppa2healthCariModel>(
      items: widget.items,
      onLoadMore: widget.onLoadMore,
      isLoadingMore: widget.isLoadingMore,
      emptyText: "Data polis tidak ditemukan.",
      columns: [
        DetailPolisColumn<Sppa2healthCariModel>(
          title: "NAMA",
          valueGetter: (d) => d.nama.isNotEmpty ? d.nama : "-",
          normalFlex: 2.2,
          compactMinWidth: 150,
          compactMaxWidth: 240,
        ),
        DetailPolisColumn<Sppa2healthCariModel>(
          title: "PAKET NAMA",
          valueGetter: (d) => d.paketNama.isNotEmpty ? d.paketNama : "-",
          normalFlex: 2.0,
          compactMinWidth: 160,
          compactMaxWidth: 260,
        ),
        DetailPolisColumn<Sppa2healthCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${formatNum(d.tsi)}",
          normalFlex: 1.7,
          compactMinWidth: 150,
          compactMaxWidth: 210,
        ),
        DetailPolisColumn<Sppa2healthCariModel>(
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