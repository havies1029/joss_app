import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';

class DetailPolisTable<T> extends StatefulWidget {
  final List<T> items;
  final List<DetailPolisColumn<T>> columns;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final String emptyText;

  final double narrowBreakpoint;
  final double headerHeight;
  final double rowHeight;
  final int maxVisibleRows;

  const DetailPolisTable({
    super.key,
    required this.items,
    required this.columns,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.emptyText = 'Data polis tidak ditemukan.',
    this.narrowBreakpoint = 900,
    this.headerHeight = 48,
    this.rowHeight = 48,
    this.maxVisibleRows = 6,
  });

  @override
  State<DetailPolisTable<T>> createState() => _DetailPolisTableState<T>();
}

class _DetailPolisTableState<T> extends State<DetailPolisTable<T>> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  final Set<String> _expandedKeys = {};

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
    if (widget.onLoadMore == null) return;
    if (!_verticalController.hasClients) return;
    if (widget.isLoadingMore) return;

    final max = _verticalController.position.maxScrollExtent;
    final cur = _verticalController.position.pixels;

    if (max - cur <= 80) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return _emptyState();

    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < widget.narrowBreakpoint;

    return isNarrow ? _buildCompactTable() : _buildNormalTable();
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: _boxDecoration(),
      alignment: Alignment.center,
      child: Text(
        widget.emptyText,
        style: bodyTextStyle(context, fontSize: 14).copyWith(
          color: primaryLightColor,
        ),
      ),
    );
  }

  Widget _buildCompactTable() {
    final widths = _compactColumnWidths(context, widget.items);

    final useVerticalScroll = widget.items.length > widget.maxVisibleRows;
    final bodyHeight = widget.maxVisibleRows * widget.rowHeight;
    final tableHeight = widget.headerHeight + bodyHeight + 12;

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        height: useVerticalScroll ? tableHeight : null,
        decoration: _boxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ScrollbarTheme(
              data: _scrollbarTheme(),
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
                          height: widget.headerHeight,
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: _tableBorder(),
                            columnWidths: widths,
                            children: [_headerRow()],
                          ),
                        ),
                        if (useVerticalScroll)
                          SizedBox(
                            height: bodyHeight,
                            child: ScrollbarTheme(
                              data: _scrollbarTheme(),
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
                            ),
                          )
                        else
                          _bodyTable(
                            widths,
                            compact: true,
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
    final useVerticalScroll = widget.items.length > widget.maxVisibleRows;
    final tableHeight =
        widget.headerHeight + (widget.maxVisibleRows * widget.rowHeight) + 12;
    final table = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: _tableBorder(),
      columnWidths: _normalColumnWidths(),
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
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        height: useVerticalScroll ? tableHeight : null,
        decoration: _boxDecoration(),
        child: useVerticalScroll
            ? ScrollbarTheme(
                data: _scrollbarTheme(),
                child: Scrollbar(
                  controller: _verticalController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    child: table,
                  ),
                ),
              )
            : table,
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
        _headerCell('NO', center: true),
        ...widget.columns.map(
          (col) => _headerCell(
            col.title,
            center: col.center,
            right: col.right,
          ),
        ),
      ],
    );
  }

  TableRow _row(
    T item,
    int index, {
    required bool compact,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cellCenter((index + 1).toString()),
        ...widget.columns.map(
          (col) {
            final value = col.valueGetter(item);
            final key = '$index-${col.title}';

            if (col.expandable) {
              return _cellExpandable(
                value,
                key: key,
                compact: compact,
              );
            }

            if (col.right) {
              return _cellRight(value);
            }

            return _cellText(
              value,
              compact: compact,
              center: col.center,
            );
          },
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
      style: bodyTextStyle(context, fontSize: 14).copyWith(
        color: primaryLightColor,
      ),
    );

    if (center) {
      child = Center(child: child);
    } else if (right) {
      child = Align(alignment: Alignment.centerRight, child: child);
    } else {
      child = Align(alignment: Alignment.centerLeft, child: child);
    }

    return SizedBox(
      height: widget.headerHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: child,
      ),
    );
  }

  Widget _cellText(
    String text, {
    required bool compact,
    bool center = false,
  }) {
    final maxLines = compact ? 4 : 3;

    Widget child = Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: bodyTextStyle(context, fontSize: 14).copyWith(
        color: primaryLightColor,
        height: 1.25,
      ),
    );

    if (center) child = Center(child: child);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Align(
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: child,
      ),
    );
  }

  Widget _cellExpandable(
    String text, {
    required String key,
    required bool compact,
  }) {
    final isExpanded = _expandedKeys.contains(key);

    final words =
        text.trim().isEmpty ? <String>[] : text.trim().split(RegExp(r'\s+'));

    final canExpand = words.length > 22;

    final style = bodyTextStyle(context, fontSize: 14).copyWith(
      color: primaryLightColor,
      height: 1.25,
    );

    final linkStyle = bodyTextStyle(context, fontSize: 14).copyWith(
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
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: style,
        ),
        if (canExpand)
          Text(
            isExpanded ? 'lihat lebih sedikit' : 'lihat lebih banyak',
            style: linkStyle,
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: canExpand
          ? InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedKeys.remove(key);
                  } else {
                    _expandedKeys.add(key);
                  }
                });
              },
              child: content,
            )
          : content,
    );
  }

  Widget _cellCenter(String text) {
    return SizedBox(
      height: widget.rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyTextStyle(context, fontSize: 14).copyWith(
              color: primaryLightColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellRight(String text) {
    return SizedBox(
      height: widget.rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: bodyTextStyle(context, fontSize: 14).copyWith(
              color: primaryLightColor,
            ),
          ),
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _normalColumnWidths() {
    final map = <int, TableColumnWidth>{
      0: const FixedColumnWidth(48),
    };

    for (var i = 0; i < widget.columns.length; i++) {
      map[i + 1] = FlexColumnWidth(widget.columns[i].normalFlex);
    }

    return map;
  }

  Map<int, TableColumnWidth> _compactColumnWidths(
    BuildContext context,
    List<T> items,
  ) {
    final map = <int, TableColumnWidth>{
      0: const FixedColumnWidth(48),
    };

    for (var i = 0; i < widget.columns.length; i++) {
      final col = widget.columns[i];

      final width = col.compactWidth ??
          _columnWidthFromLongest(
            context,
            items.map(col.valueGetter),
            min: col.compactMinWidth,
            max: col.compactMaxWidth,
          );

      map[i + 1] = FixedColumnWidth(width);
    }

    return map;
  }

  double _measureTextWidth(
    BuildContext context,
    String text, {
    TextStyle? style,
  }) {
    final effectiveStyle = style ??
        bodyTextStyle(context, fontSize: 14).copyWith(
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

  ScrollbarThemeData _scrollbarTheme() {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.1)),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(20),
      thickness: WidgetStateProperty.all(6),
    );
  }
}

class DetailPolisColumn<T> {
  final String title;
  final String Function(T item) valueGetter;

  final double normalFlex;

  final double? compactWidth;
  final double compactMinWidth;
  final double compactMaxWidth;

  final bool center;
  final bool right;
  final bool expandable;

  const DetailPolisColumn({
    required this.title,
    required this.valueGetter,
    this.normalFlex = 2,
    this.compactWidth,
    this.compactMinWidth = 140,
    this.compactMaxWidth = 260,
    this.center = false,
    this.right = false,
    this.expandable = false,
  });
}
