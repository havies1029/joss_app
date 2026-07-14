import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';

/// Reusable table design untuk COB policy list.
///
/// Tujuan file ini:
/// - Menyatukan desain table Property / Hull / Health / Others / Kargo.
/// - Perbedaan model, field, bloc event, dan popup detail tetap dikirim dari luar.
/// - Kalau nanti desain table berubah, cukup ubah widget ini.
class CobPolicyTable<T> extends StatefulWidget {
  final List<T> items;
  final List<String> selectedIds;

  /// Ambil id utama dari model. Contoh: d.asetParId / d.asetHullId.
  final String Function(T item) idGetter;

  /// Ambil nomor row. Kalau null, otomatis pakai index + 1.
  final String Function(T item, int index)? nomorGetter;

  /// Daftar kolom data setelah kolom No.
  final List<CobPolicyColumn<T>> columns;

  /// Dipanggil saat checkbox dinyalakan.
  final void Function(String id) onSelect;

  /// Dipanggil saat checkbox dimatikan.
  final void Function(String id) onUnselect;

  /// Optional: simpan selected item ke bloc.
  final void Function(T item)? onSelectItem;

  /// Optional: clear selected item dari bloc.
  final VoidCallback? onClearSelectedItem;

  /// Optional: callback tambahan saat selected, misal simpan filePolisId.
  final void Function(T item)? onSelectExtra;

  /// Optional: callback tambahan saat unselected, misal clear filePolisId.
  final void Function(T item)? onUnselectExtra;

  /// Dipakai untuk buka detail popup saat cell data diklik.
  final void Function(BuildContext context, T item) onOpenDetail;

  /// Fetch next page saat scroll bawah.
  final VoidCallback? onLoadMore;
  final bool hasReachedMax;
  final bool isFetching;

  final bool readOnly;
  final bool showFooter;
  final String? title;
  final double narrowBreakpoint;
  final bool enablePagination;
  final bool enableSelection;
  final bool enableDetailTap;

  /// Kalau true, saat readOnly hanya tampilkan item yang selected.
  final bool filterSelectedWhenReadOnly;

  const CobPolicyTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.idGetter,
    required this.columns,
    required this.onSelect,
    required this.onUnselect,
    required this.onOpenDetail,
    this.nomorGetter,
    this.onSelectItem,
    this.onClearSelectedItem,
    this.onSelectExtra,
    this.onUnselectExtra,
    this.onLoadMore,
    this.hasReachedMax = false,
    this.isFetching = false,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
    this.narrowBreakpoint = 900,
    this.enablePagination = true,
    this.enableSelection = true,
    this.enableDetailTap = true,
    this.filterSelectedWhenReadOnly = true,
  });

  @override
  State<CobPolicyTable<T>> createState() => _CobPolicyTableState<T>();
}

class _CobPolicyTableState<T> extends State<CobPolicyTable<T>> {
  late final ScrollController hController;
  late final ScrollController vController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
    vController = ScrollController();

    if (widget.enablePagination) {
      vController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    hController.dispose();

    if (widget.enablePagination) {
      vController.removeListener(_onScroll);
    }

    vController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.enablePagination) return;
    if (widget.onLoadMore == null) return;
    if (!vController.hasClients) return;

    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;
    const threshold = 100.0;

    if (max - cur <= threshold) {
      if (!widget.hasReachedMax && !widget.isFetching) {
        widget.onLoadMore?.call();
      }
    }
  }

  List<T> get _filteredItems {
    if (!widget.readOnly || !widget.filterSelectedWhenReadOnly) {
      return widget.items;
    }

    return widget.items
        .where((item) => widget.selectedIds.contains(widget.idGetter(item)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < widget.narrowBreakpoint;
    final items = _filteredItems;

    if (items.isEmpty) {
      return const Center(child: Text('Data kosong'));
    }

    return SingleChildScrollView(
      controller: vController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: Text(
                widget.title!,
                style: headingStyle(context, fontSize: 14),
              ),
            ),
            const SizedBox(height: hPadding),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
            child: isNarrow
                ? _buildCompactTable(context, items)
                : _buildNormalTable(context, items),
          ),
          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget _buildCompactTable(BuildContext context, List<T> details) {
    return _tableShell(
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          thickness: WidgetStateProperty.all(5),
          radius: const Radius.circular(cardBorderRadius),
          thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.1)),
        ),
        child: Scrollbar(
          controller: hController,
          child: SingleChildScrollView(
            controller: hController,
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: _tableBorder,
              columnWidths: _compactColumnWidths(context, details),
              children: [
                _tableHeader(context),
                ...details.asMap().entries.map(
                      (e) => _detailRow(
                    context,
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
    );
  }

  Widget _buildNormalTable(BuildContext context, List<T> details) {
    return _tableShell(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: _tableBorder,
        columnWidths: _normalColumnWidths(),
        children: [
          _tableHeader(context),
          ...details.asMap().entries.map(
                (e) => _detailRow(
              context,
              e.value,
              e.key,
              compact: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableShell({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 1),
          ),
        ),
        child: child,
      ),
    );
  }

  TableBorder get _tableBorder => const TableBorder(
    horizontalInside: BorderSide(color: sGrey, width: 1),
    verticalInside: BorderSide(color: sGrey, width: 1),
  );

  Map<int, TableColumnWidth> _normalColumnWidths() {
    final map = <int, TableColumnWidth>{
      0: widget.enableSelection
          ? const FlexColumnWidth(0.8)
          : const FixedColumnWidth(0),
      1: const FlexColumnWidth(1.0),
    };

    for (var i = 0; i < widget.columns.length; i++) {
      map[i + 2] = FlexColumnWidth(widget.columns[i].normalFlex);
    }

    return map;
  }

  Map<int, TableColumnWidth> _compactColumnWidths(BuildContext context, List<T> details) {
    final map = <int, TableColumnWidth>{
      0: FixedColumnWidth(widget.enableSelection ? 40 : 0),
      1: const FixedColumnWidth(50),
    };

    for (var i = 0; i < widget.columns.length; i++) {
      final col = widget.columns[i];
      final width = col.compactWidth ??
          _columnWidthFromLongest(
            context,
            details.map(col.valueGetter),
            min: col.compactMinWidth,
            max: col.compactMaxWidth,
          );

      map[i + 2] = FixedColumnWidth(width);
    }

    return map;
  }

  TableRow _tableHeader(BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        const SizedBox(),
        ...['NO', ...widget.columns.map((e) => e.title)].map((title) {
          final center = title.toUpperCase() == 'NO';
          final child = Text(
            title,
            style: bodyTextStyle(context, fontSize: 16),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            child: center ? Center(child: child) : child,
          );
        }),
      ],
    );
  }

  TableRow _detailRow(
      BuildContext context,
      T item,
      int index, {
        required bool compact,
      }) {
    final id = widget.idGetter(item);
    final isSelected = widget.selectedIds.contains(id);

    void triggerRow() {
      if (!widget.enableDetailTap) return;
      widget.onOpenDetail(context, item);
    }

    return TableRow(
      decoration: BoxDecoration(
        color: (!widget.readOnly && isSelected)
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        if (!widget.readOnly)
          Center(
            child: CheckboxRadio(
              value: isSelected,
              onChanged: (checked) {
                if (checked == true) {
                  widget.onSelect(id);
                  widget.onSelectItem?.call(item);
                  widget.onSelectExtra?.call(item);
                } else {
                  widget.onUnselect(id);
                  widget.onClearSelectedItem?.call();
                  widget.onUnselectExtra?.call(item);
                }
              },
            ),
          )
        else
          const SizedBox(),

        _textCell(
          widget.nomorGetter?.call(item, index) ?? '${index + 1}',
          center: true,
          softWrap: false,
        ),

        ...widget.columns.map((col) {
          return _clickableTextCell(
            col.valueGetter(item),
            onTap: triggerRow,
            maxLines: compact ? col.compactMaxLines : col.normalMaxLines,
            softWrap: compact ? col.compactSoftWrap : col.normalSoftWrap,
            center: col.center,
          );
        }),
      ],
    );
  }

  Widget _clickableTextCell(
      String text, {
        required VoidCallback onTap,
        int maxLines = 1,
        bool softWrap = false,
        bool center = false,
      }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: _textCell(
        text,
        maxLines: maxLines,
        softWrap: softWrap,
        center: center,
      ),
    );
  }

  Widget _textCell(
      String text, {
        int maxLines = 1,
        bool center = false,
        bool softWrap = true,
      }) {
    final t = Text(
      text,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      style: bodyTextStyle(context, fontSize: 14).copyWith(
        color: primaryLightColor,
      ),
    );

    return _cell(child: center ? Center(child: t) : t);
  }

  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
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
        double padding = 16,
        TextStyle? style,
      }) {
    var longest = 0.0;

    for (final v in values) {
      final w = _measureTextWidth(context, v, style: style);
      if (w > longest) longest = w;
    }

    final target = longest + padding;
    return target.clamp(min, max);
  }
}

class CobPolicyColumn<T> {
  final String title;
  final String Function(T item) valueGetter;

  /// Flex untuk normal / desktop table.
  final double normalFlex;

  /// Kalau diisi, compact width akan fixed sesuai nilai ini.
  final double? compactWidth;

  /// Kalau compactWidth null, width dihitung dari value terpanjang.
  final double compactMinWidth;
  final double compactMaxWidth;

  final int normalMaxLines;
  final int compactMaxLines;
  final bool normalSoftWrap;
  final bool compactSoftWrap;
  final bool center;

  const CobPolicyColumn({
    required this.title,
    required this.valueGetter,
    this.normalFlex = 2,
    this.compactWidth,
    this.compactMinWidth = 120,
    this.compactMaxWidth = 220,
    this.normalMaxLines = 1,
    this.compactMaxLines = 2,
    this.normalSoftWrap = false,
    this.compactSoftWrap = true,
    this.center = false,
  });
}

/// Helper formatter optional supaya parent page bisa tetap ringkas.
String cobPolicyFormatDate(DateTime? date) {
  if (date == null) return '-';
  return DateFormat('dd MMM yyyy').format(date);
}

String cobPolicyFormatNum(num? value) {
  return NumberFormat('#,##0.00', 'id_ID').format(value ?? 0);
}

String cobPolicyTextOrDash(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? '-' : text;
}
