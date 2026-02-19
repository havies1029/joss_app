import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../models/asetothers/asetotherscari_model.dart';

class KargoCobTable extends StatefulWidget {
  final List<AsetothersCariModel> items;
  final List<String> selectedIds;

  final AsetothersCariModel? selectedItem;
  final void Function(AsetothersCariModel item)? onSelectItem;
  final VoidCallback? onClearSelectedItem;

  final void Function(String id) selectedProsesId;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisHealthId;
  final Function(String id) onUnselectFilePolisHealthId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const KargoCobTable({
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
  State<KargoCobTable> createState() => _KargoCobTableState();
}
class _KargoCobTableState extends State<KargoCobTable> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);
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
    final bloc = context.read<AsetothersCariBloc>();
    final s = bloc.state;

    if (!vController.hasClients) return;
    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;

    const threshold = 100.0;

    if (max - cur <= threshold) {
      if (!s.hasReachedMax && !s.isFetching) {
        bloc.add(FetchAsetothersCariEvent());
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

  List<AsetothersCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetOthersId)).toList();
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

  // helper text cell (wrap saat compact)
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
      List<AsetothersCariModel> details,
      ) {
    final selectCol = widget.readOnly ? 0.0 : 40.0;

    final objectValues = details.map((d) => d.objectDesc);
    final polisValues = details.map((d) => d.polisNo);
    final sumInsuredValues = details.map((d) => "${d.curr} ${formatNum(d.sumInsured)}");
    final premiValues = details.map((d) => formatNum(d.premi));

    // caps = “batas mentok”
    final wObject = _columnWidthFromLongest(context, objectValues, min: 180, max: 310);
    final wPolis = _columnWidthFromLongest(context, polisValues, min: 120, max: 180);
    final wSumInsured = _columnWidthFromLongest(context, sumInsuredValues, min: 170, max: 240);
    final wPremi = _columnWidthFromLongest(context, premiValues, min: 110, max: 140);

    return {
      0: FixedColumnWidth(selectCol),
      1: const FixedColumnWidth(50), // No
      2: FixedColumnWidth(wObject),
      3: FixedColumnWidth(wPolis),
      4: FixedColumnWidth(wSumInsured),
      5: FixedColumnWidth(wPremi),
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

  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsetothersCariModel> details,
      ) {
    if (details.isEmpty) return const Text("Tidak ada detail");

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
            thumbVisibility: MaterialStateProperty.all(true),
            trackVisibility: MaterialStateProperty.all(false),
            thickness: MaterialStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: MaterialStateProperty.all(scrollBar.withOpacity(0.1)),
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
                        (e) => _detailRowWithRadioLikeProperty(
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

  Widget _buildDetailTableNormal(
      BuildContext context,
      List<AsetothersCariModel> details,
      ) {
    if (details.isEmpty) return const Text("Tidak ada detail");

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
            2: const FlexColumnWidth(3.6),
            3: const FlexColumnWidth(2.3),
            4: const FlexColumnWidth(3.0),
            5: const FlexColumnWidth(1.6),
          },
          children: [
            _tableHeader(context),
            ...details.asMap().entries.map(
                  (e) => _detailRowWithRadioLikeProperty(
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
        const SizedBox(),
        ...[
          "No",
          "Object",
          "Polis No",
          "Sum Insured",
          "Premi",
        ].map((t) {
          final center = t.toUpperCase() == "NO";
          final child = Text(t, style: bodyTextStyle(context, fontSize: 15));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            child: center ? Center(child: child) : child,
          );
        }).toList(),
      ],
    );
  }

  TableRow _detailRowWithRadioLikeProperty(
      BuildContext context,
      AsetothersCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedItem == d;

    // wrap rules saat mentok max width
    final maxLinesObject = compact ? 3 : 1;
    final maxLinesPolis = compact ? 2 : 1;

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
                    widget.onUnselect(prev.asetOthersId);
                    if (prev.filePolisId.isNotEmpty) {
                      widget.onUnselectFilePolisHealthId(prev.filePolisId);
                    }
                  }

                  widget.onSelect(d.asetOthersId);
                  widget.onSelectItem?.call(d);

                  if (d.prosesId.isNotEmpty) {
                    widget.selectedProsesId(d.prosesId);
                  }

                  if (d.filePolisId.isNotEmpty) {
                    widget.onSelectFilePolisHealthId(d.filePolisId);
                  }
                } else {
                  widget.onUnselect(d.asetOthersId);
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
          d.objectDesc,
          maxLines: maxLinesObject,
          softWrap: true,
        ),

        _textCell(
          d.polisNo,
          maxLines: maxLinesPolis,
          softWrap: true,
        ),

        _textCell(
          "${d.curr} ${formatNum(d.sumInsured)}",
          maxLines: 1,
          softWrap: false,
        ),

        _textCell(
          formatNum(d.premi),
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }

  // kamu minta cell jangan diubah: tetap sama
  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
