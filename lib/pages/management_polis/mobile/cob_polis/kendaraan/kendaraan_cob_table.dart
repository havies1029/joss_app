import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_mv/asetmvcari_model.dart';
import 'detail_polis_mv_table_page.dart';

class KendaraanCobTable extends StatefulWidget {
  final List<AsetMvCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetMvCariModel item)? onSelectItem;
  final void Function(String id) selectedProsesId;
  final AsetMvCariModel? selectedItem;
  final VoidCallback? onClearSelectedItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisMvId;
  final Function(String id) onUnselectFilePolisMvId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const KendaraanCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisMvId,
    required this.onUnselectFilePolisMvId,
    required this.selectedItem,
    required this.onClearSelectedItem,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<KendaraanCobTable> createState() => _KendaraanCobTableState();
}
class _KendaraanCobTableState extends State<KendaraanCobTable> {
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

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
    final bloc = context.read<AsetMvCariBloc>();
    final s = bloc.state;

    if (!vController.hasClients) return;
    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;

    const threshold = 80.0;

    if (max - cur <= threshold) {
      if (!s.hasReachedMax && !s.isFetching) {
        bloc.add(FetchAsetMvCariEvent());
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

  List<AsetMvCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetMvId)).toList();
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

  // cell text helper: wrap kalau compact dan sudah mentok width
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

  // =========================
  // Compact column widths (dynamic + clamp)
  // =========================

  Map<int, TableColumnWidth> _compactColumnWidths(
      BuildContext context,
      List<AsetMvCariModel> details,
      ) {
    final selectCol = widget.readOnly ? 0.0 : 40.0;

    final tertanggungValues = details.map((d) => d.tertanggung);
    // final merkValues = details.map((d) => d.merk);
    // final nopolValues = details.map((d) => d.noPolisi);

    const periodeWidth = 170.0;

    final nilaiValues = details.map((d) => "${d.curr} ${formatNum(d.sumInsured)}");
    final premiValues = details.map((d) => "${d.curr} ${formatNum(d.premi)}");
    final polisValues = details.map((d) => d.polisNo);
    final jmlObjectValues = details.map((d) => d.jmlObject.toString());

    final wTertanggung = _columnWidthFromLongest(context, tertanggungValues, min: 140, max: 200);
    // final wMerk = _columnWidthFromLongest(context, merkValues, min: 110, max: 160);
    // final wNoPol = _columnWidthFromLongest(context, nopolValues, min: 120, max: 170);
    final wNilai = _columnWidthFromLongest(context, nilaiValues, min: 150, max: 190);
    final wPremi = _columnWidthFromLongest(context, premiValues, min: 120, max: 160);
    final wPolis = _columnWidthFromLongest(context, polisValues, min: 120, max: 170);
    final wJmlObject = _columnWidthFromLongest(
      context,
      jmlObjectValues,
      min: 110,
      max: 140,
    );

    // return {
    //   0: FixedColumnWidth(selectCol),
    //   1: const FixedColumnWidth(50),
    //   2: FixedColumnWidth(wPolis),
    //   3: const FixedColumnWidth(periodeWidth),
    //   4: FixedColumnWidth(wMerk),
    //   5: FixedColumnWidth(wNoPol),
    //   6: FixedColumnWidth(wTertanggung),
    //   7: FixedColumnWidth(wNilai),
    //   8: FixedColumnWidth(wPremi),
    // };
    return {
      0: FixedColumnWidth(selectCol),
      1: const FixedColumnWidth(50), // No
      2: FixedColumnWidth(wPolis), // Polis No
      3: FixedColumnWidth(wJmlObject), // Jml Object
      4: const FixedColumnWidth(periodeWidth), // Periode
      5: FixedColumnWidth(wTertanggung), // Tertanggung
      6: FixedColumnWidth(wNilai), // Nilai Pertanggungan
      7: FixedColumnWidth(wPremi), // Premi
    };
  }

  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    final items = _filteredItems;
    if (items.isEmpty) return const Center(child: Text("Data kosong"));

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

  // =========================
  // Compact (dynamic widths + wrap)
  // =========================

  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsetMvCariModel> details,
      ) {
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
                        (e) => _detailRowWithCheckbox(
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

  // =========================
  // Normal (biarin flex, stabil)
  // =========================

  Widget _buildDetailTableNormal(BuildContext context, List<AsetMvCariModel> details) {
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
            1: const FlexColumnWidth(1.0), // No
            2: const FlexColumnWidth(2.0), // Polis No
            3: const FlexColumnWidth(1.2), // Jml Object
            4: const FlexColumnWidth(2.0), // Periode
            5: const FlexColumnWidth(2.4), // Tertanggung
            6: const FlexColumnWidth(2.4), // Nilai Pertanggungan
            7: const FlexColumnWidth(1.6), // Premi
          },
          children: [
            _tableHeader(context),
            ...details.asMap().entries.map(
                  (e) => _detailRowWithCheckbox(
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

  // =========================
  // Header
  // =========================

  TableRow _tableHeader(BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        const SizedBox(),
        ...[
          "No",
          "Polis No",
          "Jumlah Objek",
          "Periode",
          "Tertanggung",
          "Nilai Pertanggungan",
          "Premi",
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

  // =========================
  // Row (wrap saat compact)
  // =========================

  TableRow _detailRowWithCheckbox(
      BuildContext context,
      AsetMvCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedItem == d;

    final maxLinesTertanggung = compact ? 2 : 1;
    final maxLinesNoPol = compact ? 2 : 1;

    void triggerRow() {
      if (widget.readOnly) return;
      _showSuccessPopup(context, d);
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
                  widget.onSelect(d.asetMvId);
                  widget.onSelectItem?.call(d);

                  if (d.filePolisId.isNotEmpty) {
                    widget.onSelectFilePolisMvId(d.filePolisId);
                  }
                } else {
                  widget.onUnselect(d.asetMvId);
                  widget.onClearSelectedItem?.call();

                  if (d.filePolisId.isNotEmpty) {
                    widget.onUnselectFilePolisMvId(d.filePolisId);
                  }
                }
              },
            ),
          )
        else
          const SizedBox(),

        _textCell(d.nomor.toString(), center: true, softWrap: false),

        _clickableTextCell(
          d.polisNo,
          onTap: triggerRow,
          maxLines: compact ? 2 : 1,
          softWrap: true,
        ),

        _clickableTextCell(
          "${d.jmlObject} ${d.satuan}",
          onTap: triggerRow,
          maxLines: maxLinesNoPol,
          softWrap: true,
        ),

        _clickableTextCell(
          "${DateFormat('dd MMM yyyy').format(d.periodeMulai)} - "
              "${DateFormat('dd MMM yyyy').format(d.periodeAkhir)}",
          onTap: triggerRow,
          maxLines: compact ? 2 : 1,
          softWrap: true,
        ),

        _clickableTextCell(
          d.tertanggung,
          onTap: triggerRow,
          maxLines: maxLinesTertanggung,
          softWrap: true,
        ),

        _clickableTextCell(
          "${d.curr} ${formatNum(d.sumInsured)}",
          onTap: triggerRow,
          maxLines: 1,
          softWrap: false,
        ),

        _clickableTextCell(
          "${d.curr} ${formatNum(d.premi)}",
          onTap: triggerRow,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsetMvCariModel d) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: DetailPolisMvTablePage(
            sppa1Id: d.asetMvId,
          ),
        );
      },
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

  Widget _cell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
