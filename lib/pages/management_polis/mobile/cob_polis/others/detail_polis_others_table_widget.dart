
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/asetothers/sppa2otherscari_model.dart';

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
  final ScrollController _verticalController = ScrollController();

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);


  void _onScroll() {
    if (!_verticalController.hasClients) return;
    if (widget.isLoadingMore) return;

    final max = _verticalController.position.maxScrollExtent;
    final cur = _verticalController.position.pixels;

    const threshold = 80.0;

    if (max - cur <= threshold) {
      widget.onLoadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    _verticalController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _verticalController.removeListener(_onScroll);
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
                    0: FlexColumnWidth(0.7),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1.6),
                    5: FlexColumnWidth(1.6),
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
        _HeaderCell("Lokasi"),
        _HeaderCell("Nilai Pertanggungan", right: true),
        _HeaderCell("Premi", right: true),
      ],
    );
  }

  TableRow _row(
      Sppa2othersCariModel d,
      int index, {
        required bool compact,
      }) {
    final tsi = "${d.curr} ${formatNum(d.tsi)}";
    final premi = "${d.curr} ${formatNum(d.premiNet)}";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(d.info1.isNotEmpty ? d.info1 : "-", compact: compact),
        _cellRight(tsi),
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