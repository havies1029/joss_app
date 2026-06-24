import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_mv/sppa2mvcari_model.dart';
import '../template_polis_table/detail_polis_table.dart';

class DetailPolisMvTableWidget extends StatefulWidget {
  final List<Sppa2mvCariModel> items;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  const DetailPolisMvTableWidget({
    super.key,
    required this.items,
    required this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<DetailPolisMvTableWidget> createState() =>
      _DetailPolisMvTableWidgetState();
}

class _DetailPolisMvTableWidgetState extends State<DetailPolisMvTableWidget> {
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

  String merkGabungan(Sppa2mvCariModel d) {
    final value = [
      d.merk,
      d.jenisMv,
      d.modelMv,
    ].where((e) =>
    e
        .trim()
        .isNotEmpty).join(" - ");

    return value.isNotEmpty ? value : "-";
  }

  @override
  Widget build(BuildContext context) {
    return DetailPolisTable<Sppa2mvCariModel>(
      items: widget.items,
      onLoadMore: widget.onLoadMore,
      isLoadingMore: widget.isLoadingMore,
      emptyText: "Data polis tidak ditemukan.",
      columns: [
        DetailPolisColumn<Sppa2mvCariModel>(
          title: "NO POLISI",
          valueGetter: (d) => d.polisiNo.isNotEmpty ? d.polisiNo : "-",
          normalFlex: 1.1,
          compactMinWidth: 110,
          compactMaxWidth: 150,
        ),
        DetailPolisColumn<Sppa2mvCariModel>(
          title: "MERK KENDARAAN",
          valueGetter: merkGabungan,
          normalFlex: 2.5,
          compactMinWidth: 220,
          compactMaxWidth: 360,
        ),
        DetailPolisColumn<Sppa2mvCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${formatNum(d.harga)}",
          normalFlex: 1.7,
          compactMinWidth: 150,
          compactMaxWidth: 210,
        ),
        DetailPolisColumn<Sppa2mvCariModel>(
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