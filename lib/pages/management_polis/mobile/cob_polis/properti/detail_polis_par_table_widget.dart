import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_par/sppa2parcari_model.dart';

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
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  static const double _headerHeight = 48;
  static const double _rowHeight = 48;
  static const int _maxVisibleRows = 7;

  final Set<int> _expandedDescIndexes = {};

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
              0: FixedColumnWidth(38),
              1: FixedColumnWidth(48),
              2: FlexColumnWidth(2.2),
              3: FlexColumnWidth(1.8),
              4: FlexColumnWidth(1.5),
              5: FlexColumnWidth(2.4),
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
        _headerCell("LOKASI"),
        _headerCell("NILAI PERTANGGUNGAN"),
        _headerCell("PREMI"),
        _headerCell("DESKRIPSI"),
      ],
    );
  }

  TableRow _row(
      Sppa2parCariModel d,
      int index, {
        required bool compact,
      }) {
    final lokasi = d.lokasi1.isNotEmpty ? d.lokasi1 : "-";
    final desc = d.okupasiDesc.isNotEmpty ? d.okupasiDesc : "-";
    final tsi = "${d.curr} ${formatNum(d.tsiTotal)}";
    final premi = "${d.curr} ${formatNum(d.premiNet)}";

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        _cellText(lokasi, compact: compact),
        _cellText(tsi, compact: compact),
        _cellText(premi, compact: compact),
        _cellDescription(
          desc,
          index: index,
          compact: compact,
        ),
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

  Widget _cellDescription(
      String text, {
        required int index,
        required bool compact,
      }) {
    final isExpanded = _expandedDescIndexes.contains(index);

    final words = text.trim().isEmpty
        ? <String>[]
        : text.trim().split(RegExp(r'\s+'));

    final canExpand = words.length > 22;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Builder(
        builder: (context) {
          final style = bodyTextStyle(context, fontSize: 12).copyWith(
            color: primaryLightColor,
            height: 1.25,
          );

          final linkStyle = bodyTextStyle(context, fontSize: 12).copyWith(
            color: dBlue,
            height: 1.25,
            fontWeight: FontWeight.w600,
          );

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                maxLines: isExpanded ? null : 3,
                overflow: isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: style,
              ),
              if (canExpand)
                Text(
                  isExpanded ? "lihat lebih sedikit" : "lihat lebih banyak",
                  style: linkStyle,
                ),
            ],
          );

          if (!canExpand) return content;

          return InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedDescIndexes.remove(index);
                } else {
                  _expandedDescIndexes.add(index);
                }
              });
            },
            child: content,
          );
        },
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
      List<Sppa2parCariModel> items,
      ) {
    final lokasiValues = items.map(
          (d) => d.lokasi1.isNotEmpty ? d.lokasi1 : "-",
    );

    final tsiValues = items.map(
          (d) => "${d.curr} ${formatNum(d.tsiTotal)}",
    );

    final premiValues = items.map(
          (d) => "${d.curr} ${formatNum(d.premiNet)}",
    );

    final descValues = items.map(
          (d) => d.okupasiDesc.isNotEmpty ? d.okupasiDesc : "-",
    );

    return {
      0: const FixedColumnWidth(48),
      1: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          lokasiValues,
          min: 150,
          max: 240,
        ),
      ),
      2: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          tsiValues,
          min: 135,
          max: 180,
        ),
      ),
      3: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          premiValues,
          min: 115,
          max: 160,
        ),
      ),
      4: FixedColumnWidth(
        _columnWidthFromLongest(
          context,
          descValues,
          min: 160,
          max: 260,
        ),
      ),
    };
  }
}