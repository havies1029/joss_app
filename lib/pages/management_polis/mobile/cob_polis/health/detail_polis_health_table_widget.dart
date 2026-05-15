import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_health/sppa2healthcari_model.dart';

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
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  static const double _headerHeight = 48;
  static const double _rowHeight = 48;
  static const int _maxVisibleRows = 7;

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  @override
  void initState() {
    super.initState();
    _verticalController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _verticalController.removeListener(_onScroll);
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_verticalController.hasClients) return;
    if (widget.isLoadingMore) return;

    final max = _verticalController.position.maxScrollExtent;
    final cur = _verticalController.position.pixels;

    if (max - cur <= 80) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    if (widget.items.isEmpty) {
      return _emptyState();
    }

    return isNarrow ? _buildCompactTable() : _buildNormalTable();
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: _boxDecoration(),
      alignment: Alignment.center,
      child: Text(
        "Data polis tidak ditemukan.",
        style: bodyTextStyle(context, fontSize: 13).copyWith(
          color: primaryLightColor,
        ),
      ),
    );
  }

  Widget _buildCompactTable() {
    final widths = _compactColumnWidths(context, widget.items);

    final visibleRows = widget.items.length > _maxVisibleRows
        ? _maxVisibleRows
        : widget.items.length;

    final bodyHeight = visibleRows * _rowHeight;
    final tableHeight = _headerHeight + bodyHeight + 12;
    final useVerticalScroll = widget.items.length > _maxVisibleRows;

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        height: tableHeight,
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(hintGrey),
                trackColor: WidgetStateProperty.all(
                  hintGrey.withOpacity(.15),
                ),
                trackBorderColor: WidgetStateProperty.all(
                  Colors.transparent,
                ),
                radius: const Radius.circular(20),
                thickness: WidgetStateProperty.all(6),
              ),
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: _headerHeight,
                          child: Table(
                            defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                            border: _tableBorder(),
                            columnWidths: widths,
                            children: [_headerRow()],
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight,
                          child: useVerticalScroll
                              ? ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor:
                              WidgetStateProperty.all(hintGrey),
                              trackColor: WidgetStateProperty.all(
                                hintGrey.withOpacity(.15),
                              ),
                              trackBorderColor:
                              WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              radius: const Radius.circular(20),
                              thickness: WidgetStateProperty.all(6),
                            ),
                            child: Scrollbar(
                              controller: _verticalController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                controller: _verticalController,
                                child: _bodyTable(
                                  widths,
                                  compact: true,
                                ),
                              ),
                            ),
                          )
                              : _bodyTable(
                            widths,
                            compact: true,
                          ),
                        ),
                      ],
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
        child: SingleChildScrollView(
          controller: _verticalController,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: _tableBorder(),
            columnWidths: const {
              0: FixedColumnWidth(48),
              1: FlexColumnWidth(2.2),
              2: FlexColumnWidth(2.0),
              3: FlexColumnWidth(1.7),
              4: FlexColumnWidth(1.5),
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
      ),
    );
  }

  Table _bodyTable(
      Map<int, TableColumnWidth> widths, {
        required bool compact,
      }) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: _tableBorder(),
      columnWidths: widths,
      children: [
        ...widget.items.asMap().entries.map(
              (e) => _row(
            e.value,
            e.key,
            compact: compact,
          ),
        ),
      ],
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        _headerCell("NO", center: true),
        _headerCell("NAMA"),
        _headerCell("PAKET NAMA"),
        _headerCell("NILAI PERTANGGUNGAN", right: true),
        _headerCell("PREMI", right: true),
      ],
    );
  }

  TableRow _row(
      Sppa2healthCariModel d,
      int index, {
        required bool compact,
      }) {
    final nama = d.nama.isNotEmpty ? d.nama : "-";
    final paketNama = d.paketNama.isNotEmpty ? d.paketNama : "-";
    final tsi = "${d.curr} ${formatNum(d.tsi)}";
    final premi = "${d.curr} ${formatNum(d.premiNet)}";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(nama, compact: compact),
        _cellText(paketNama, compact: compact),
        _cellRight(tsi),
        _cellRight(premi),
      ],
    );
  }

  Widget _headerCell(
      String text, {
        bool center = false,
        bool right = false,
      }) {
    Widget child = Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: bodyTextStyle(context, fontSize: 12).copyWith(
        color: primaryLightColor,
      ),
    );

    if (center) {
      child = Center(child: child);
    } else if (right) {
      child = Align(
        alignment: Alignment.centerRight,
        child: child,
      );
    } else {
      child = Align(
        alignment: Alignment.centerLeft,
        child: child,
      );
    }

    return SizedBox(
      height: _headerHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: child,
      ),
    );
  }

  Widget _cellText(
      String text, {
        required bool compact,
      }) {
    final maxLines = compact ? 4 : 3;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: bodyTextStyle(context, fontSize: 12).copyWith(
            color: primaryLightColor,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  Widget _cellCenter(String text) {
    return SizedBox(
      height: _rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyTextStyle(context, fontSize: 12).copyWith(
              color: primaryLightColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellRight(String text) {
    return SizedBox(
      height: _rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: bodyTextStyle(context, fontSize: 12).copyWith(
              color: primaryLightColor,
            ),
          ),
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
        bottom: BorderSide(color: sGrey, width: 1),
      ),
    );
  }

  TableBorder _tableBorder() {
    return const TableBorder(
      horizontalInside: BorderSide(color: sGrey, width: 1),
      verticalInside: BorderSide(color: sGrey, width: 1),
    );
  }

  double _measureTextWidth(
      BuildContext context,
      String text, {
        TextStyle? style,
      }) {
    final effectiveStyle = style ??
        bodyTextStyle(context, fontSize: 12).copyWith(
          color: primaryLightColor,
        );

    final tp = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
      ellipsis: '…',
    )..layout();

    return tp.width;
  }

  double _columnWidthFromLongest(
      BuildContext context,
      Iterable<String> values, {
        required double min,
        required double max,
        double padding = 24,
      }) {
    var longest = 0.0;

    for (final value in values) {
      final width = _measureTextWidth(context, value);
      if (width > longest) longest = width;
    }

    return (longest + padding).clamp(min, max);
  }

  Map<int, TableColumnWidth> _compactColumnWidths(
      BuildContext context,
      List<Sppa2healthCariModel> items,
      ) {
    final namaValues = items.map(
          (d) => d.nama.isNotEmpty ? d.nama : "-",
    );

    final paketValues = items.map(
          (d) => d.paketNama.isNotEmpty ? d.paketNama : "-",
    );

    final tsiValues = items.map(
          (d) => "${d.curr} ${formatNum(d.tsi)}",
    );

    final premiValues = items.map(
          (d) => "${d.curr} ${formatNum(d.premiNet)}",
    );

    return {
      0: const FixedColumnWidth(48),
      1: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          namaValues,
          min: 150,
          max: 240,
        ),
      ),
      2: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          paketValues,
          min: 160,
          max: 260,
        ),
      ),
      3: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          tsiValues,
          min: 150,
          max: 210,
        ),
      ),
      4: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          premiValues,
          min: 120,
          max: 180,
        ),
      ),
    };
  }
}