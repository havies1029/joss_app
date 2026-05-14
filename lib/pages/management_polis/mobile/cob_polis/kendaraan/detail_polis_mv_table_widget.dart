import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_mv/sppa2mvcari_model.dart';

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
  final ScrollController _verticalController = ScrollController();

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  @override
  void initState() {
    super.initState();

    _verticalController.addListener(() {
      if (widget.isLoadingMore) return;

      if (_verticalController.position.pixels >=
          _verticalController.position.maxScrollExtent - 80) {
        widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return isNarrow ? _buildCompactTable() : _buildNormalTable();
  }

  Widget _buildCompactTable() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              child: SingleChildScrollView(
                controller: _verticalController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: IntrinsicWidth(
                      child: Table(
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        border: _tableBorder(),
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: IntrinsicColumnWidth(),
                          3: IntrinsicColumnWidth(),
                          4: IntrinsicColumnWidth(),
                        },
                        children: [
                          _headerRow(),
                          ...widget.items.asMap().entries.map(
                                (e) => _row(
                              e.value,
                              e.key,
                              compact: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNormalTable() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _verticalController,
              child: SizedBox(
                width: constraints.maxWidth,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: _tableBorder(),
                  columnWidths: const {
                    0: FixedColumnWidth(50),
                    1: FixedColumnWidth(130),
                    2: FixedColumnWidth(300),
                    3: FixedColumnWidth(180),
                    4: FixedColumnWidth(150),
                  },
                  children: [
                    _headerRow(),
                    ...widget.items.asMap().entries.map(
                          (e) => _row(
                        e.value,
                        e.key,
                        compact: false,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: formGrey,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: const Border(
        top: BorderSide(color: sGrey, width: 1),
        left: BorderSide(color: sGrey, width: 1),
        right: BorderSide(color: sGrey, width: 1),
        bottom: BorderSide(color: sGrey, width: 0.5),
      ),
    );
  }

  TableBorder _tableBorder() {
    return const TableBorder(
      horizontalInside: BorderSide(color: sGrey, width: 1),
      verticalInside: BorderSide(color: sGrey, width: 1),
    );
  }

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: [
        _HeaderCell("No", center: true),
        _HeaderCell("No Polisi"),
        _HeaderCell("Merk Kendaraan"),
        _HeaderCell("Nilai Pertanggungan", right: true),
        _HeaderCell("Premi", right: true),
      ],
    );
  }

  TableRow _row(
      Sppa2mvCariModel d,
      int index, {
        required bool compact,
      }) {
    final harga = "${d.curr} ${formatNum(d.harga)}";
    final premi = "${d.curr} ${formatNum(d.premiNet)}";

    final merkGabungan = [
      d.merk,
      d.modelMv,
      d.jenisMv,
    ].where((e) => e.trim().isNotEmpty).join(" - ");

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(d.polisiNo.isNotEmpty ? d.polisiNo : "-", compact: compact),
        _cellText(merkGabungan.isNotEmpty ? merkGabungan : "-", compact: compact),
        _cellRight(harga),
        _cellRight(premi),
      ],
    );
  }

  Widget _cellText(String text, {required bool compact}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        maxLines: compact ? 2 : null,
        overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
        style: TextStyle(
          color: primaryLightColor,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _cellCenter(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: primaryLightColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _cellRight(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: TextStyle(
            color: primaryLightColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final bool center;
  final bool right;

  const _HeaderCell(
      this.text, {
        this.center = false,
        this.right = false,
      });

  @override
  Widget build(BuildContext context) {
    Widget child = Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryLightColor,
      ),
    );

    if (center) {
      child = Center(child: child);
    }

    if (right) {
      child = Align(
        alignment: Alignment.centerRight,
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      child: child,
    );
  }
}