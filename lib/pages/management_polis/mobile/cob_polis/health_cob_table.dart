import 'package:flutter/material.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../models/gen_aset_health/asethealthcari_model.dart';

class HealthCobTable extends StatefulWidget {
  final List<AsetHealthCariModel> items;
  final List<String> selectedIds;

  final AsetHealthCariModel? selectedItem;
  final void Function(AsetHealthCariModel item)? onSelectItem;
  final VoidCallback? onClearSelectedItem;

  final void Function(String id) selectedProsesId;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisHealthId;
  final Function(String id) onUnselectFilePolisHealthId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const HealthCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.selectedItem,
    required this.onSelectItem,
    required this.onClearSelectedItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisHealthId,
    required this.onUnselectFilePolisHealthId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<HealthCobTable> createState() => _HealthCobTableState();
}
class _HealthCobTableState extends State<HealthCobTable> {
  late final ScrollController hController;
  late final ScrollController vController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
    vController = ScrollController();
    vController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<AsetHealthCariBloc>();
    final s = bloc.state;

    if (!vController.hasClients) return;
    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;

    const threshold = 100.0;

    if (max - cur <= threshold) {
      if (!s.hasReachedMax && !s.isFetching) {
        bloc.add(FetchAsetHealthCariEvent());
      }
    }
  }

  @override
  void dispose() {
    hController.dispose();
    vController.removeListener(_onScroll);
    vController.dispose();
    super.dispose();
  }

  List<AsetHealthCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asethealthId)).toList();
  }

  // =========================
  // Dynamic width helpers
  // =========================

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
      style: const TextStyle(color: primaryLightColor),
    );
    return _cell(child: center ? Center(child: t) : t);
  }

  Map<int, TableColumnWidth> _compactColumnWidths(
      BuildContext context,
      List<AsetHealthCariModel> details,
      ) {
    final selectCol = widget.readOnly ? 0.0 : 40.0;

    final namaValues = details.map((d) => d.nama);
    final benefitValues = details.map((d) => (d.status ?? '-'));

    // caps: ngikut style awalmu (Nama 250, Benefit 290)
    final wNama = _columnWidthFromLongest(context, namaValues, min: 180, max: 250);
    final wBenefit = _columnWidthFromLongest(context, benefitValues, min: 200, max: 290);

    return {
      0: FixedColumnWidth(selectCol),
      1: const FixedColumnWidth(50), // No
      2: FixedColumnWidth(wNama),
      3: FixedColumnWidth(wBenefit),
    };
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    final items = _filteredItems;

    if (items.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    return SingleChildScrollView(
      controller: vController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: Text(widget.title!, style: headingStyle(context, fontSize: 14)),
            ),
            const SizedBox(height: hPadding),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
            child: isNarrow
                ? _buildDetailTableCompact(context, items)
                : _buildDetailTableNormal(context, items),
          ),
          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget _buildDetailTableCompact(BuildContext context, List<AsetHealthCariModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    final columnWidths = _compactColumnWidths(context, details);

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
                border: const TableBorder(
                  horizontalInside: BorderSide(color: sGrey, width: 1),
                  verticalInside: BorderSide(color: sGrey, width: 1),
                ),
                columnWidths: columnWidths,
                children: [
                  _tableHeader(context),
                  ...details.asMap().entries.map(
                        (e) => _detailRowWithRadioStyle(
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
      ),
    );
  }

  Widget _buildDetailTableNormal(BuildContext context, List<AsetHealthCariModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

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
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
            verticalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: {
            0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8),
            1: const FlexColumnWidth(1.0),
            2: const FlexColumnWidth(3.9),
            3: const FlexColumnWidth(3.7),
          },
          children: [
            _tableHeader(context),
            ...details.asMap().entries.map(
                  (e) => _detailRowWithRadioStyle(
                context,
                e.value,
                e.key,
                compact: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _tableHeader(BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        const SizedBox(), // property style
        ...[
          "No",
          "Nama",
          "Benefit",
        ].map((t) {
          final center = t.toUpperCase() == "NO";
          final child = Text(t, style: bodyTextStyle(context, fontSize: 15));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            child: center ? Center(child: child) : child,
          );
        }),
      ],
    );
  }

  TableRow _detailRowWithRadioStyle(
      BuildContext context,
      AsetHealthCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedItem == d;

    // wrap rules saat mentok max width (compact)
    final maxLinesNama = compact ? 2 : 1;
    final maxLinesBenefit = compact ? 3 : 2;

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
                  final prev = widget.selectedItem;
                  if (prev != null && prev != d) {
                    widget.onUnselect(prev.asethealthId);
                    if (prev.filePolisId.isNotEmpty) {
                      widget.onUnselectFilePolisHealthId(prev.filePolisId);
                    }
                  }

                  widget.selectedProsesId(d.prosesId);
                  widget.onSelect(d.asethealthId);
                  widget.onSelectItem?.call(d);

                  if (d.filePolisId.isNotEmpty) {
                    widget.onSelectFilePolisHealthId(d.filePolisId);
                  }
                } else {
                  widget.onUnselect(d.asethealthId);
                  widget.selectedProsesId("");
                  widget.onClearSelectedItem?.call();

                  if (d.filePolisId.isNotEmpty) {
                    widget.onUnselectFilePolisHealthId(d.filePolisId);
                  }
                }
              },
            ),
          )
        else
          const SizedBox(),

        _textCell(d.nomor.toString(), center: true, softWrap: false),

        _textCell(
          d.nama,
          maxLines: maxLinesNama,
          softWrap: true,
        ),

        _textCell(
          d.status ?? '-',
          maxLines: maxLinesBenefit,
          softWrap: true,
        ),
      ],
    );
  }

  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
