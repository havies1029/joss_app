import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_aset_par/asetparcari_model.dart';

class PropertyCobTable extends StatefulWidget {
  final List<AsetParCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetParCariModel item)? onSelectItem;
  final void Function(String id) selectedProsesId;
  final AsetParCariModel? selectedItem;
  final VoidCallback? onClearSelectedItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisParId;
  final Function(String id) onUnselectFilePolisParId;

  final Function(String id) onSelectFilePolisEqId;
  final Function(String id) onUnselectFilePolisEqId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  final String statusId;

  const PropertyCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisParId,
    required this.onUnselectFilePolisParId,
    required this.onSelectFilePolisEqId,
    required this.onUnselectFilePolisEqId,
    required this.selectedItem,
    required this.onClearSelectedItem,
    required this.statusId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<PropertyCobTable> createState() => _PropertyCobTableState();
}
class _PropertyCobTableState extends State<PropertyCobTable> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);
  late final ScrollController hController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
  }

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }

  List<AsetParCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetParId)).toList();
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
        double padding = 16, // padding cell + sedikit buffer
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

  // Helper cell text yang otomatis wrap (biar “mentok width => jadi baris”)
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
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    final showColumn = widget.statusId == "10002";
    final items = _filteredItems;

    if (items.isEmpty) {
      return const Center(child: Text("Data kosong"));
    }

    return SingleChildScrollView(
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
                ? _buildDetailTableCompact(context, items, showColumn)
                : _buildDetailTableNormal(context, items, showColumn),
          ),
          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  // =========================
  // Column width specs (caps)
  // =========================
  // Kamu bebas ubah cap max di sini (inilah “batas mentok”-nya)
  // width akan ngikut data terpanjang tapi mentok di max.

  Map<int, TableColumnWidth> _compactColumnWidths(
      BuildContext context,
      List<AsetParCariModel> details,
      bool showColumn,
      ) {
    final selectCol = widget.readOnly ? 0.0 : 40.0;

    // buat kumpulin string per kolom
    final noProsesValues = details.map((d) => d.prosesId.isEmpty ? "-" : d.prosesId);
    final noPolisValues = details.map((d) => d.polisNo);
    final tertanggungValues = details.map((d) => d.tertanggung);
    final alamatValues = details.map((d) => d.alamat);

    // Periode: format cenderung sama panjang, aman fixed/cap
    const periodeWidth = 180.0;

    // Nilai/Premi: juga relatif, tapi tetap kita clamp kecil
    final nilaiValues = details.map((d) => "${d.curr} ${formatNum(d.sumInsured)}");
    final premiValues = details.map((d) => "${d.curr} ${formatNum(d.premi)}");

    // Spec caps (min/max)
    final wNoProses = _columnWidthFromLongest(context, noProsesValues, min: 90, max: 140);
    final wNoPolis = _columnWidthFromLongest(context, noPolisValues, min: 110, max: showColumn ? 120 : 160);
    final wTertanggung = _columnWidthFromLongest(context, tertanggungValues, min: 130, max: 170);
    final wAlamat = _columnWidthFromLongest(context, alamatValues, min: 160, max: 240);
    final wNilai = _columnWidthFromLongest(context, nilaiValues, min: 140, max: 170);
    final wPremi = _columnWidthFromLongest(context, premiValues, min: 120, max: 140);

    // Susun map berdasarkan showColumn
    if (showColumn) {
      return {
        0: FixedColumnWidth(selectCol),
        1: const FixedColumnWidth(50), // No
        2: FixedColumnWidth(wNoProses),
        3: FixedColumnWidth(wNoPolis),
        4: FixedColumnWidth(wTertanggung),
        5: FixedColumnWidth(wAlamat),
        6: const FixedColumnWidth(periodeWidth),
        7: FixedColumnWidth(wNilai),
        8: FixedColumnWidth(wPremi),
      };
    }

    return {
      0: FixedColumnWidth(selectCol),
      1: const FixedColumnWidth(50), // No
      2: FixedColumnWidth(wNoPolis),
      3: FixedColumnWidth(wTertanggung),
      4: FixedColumnWidth(wAlamat),
      5: const FixedColumnWidth(periodeWidth),
      6: FixedColumnWidth(wNilai),
      7: FixedColumnWidth(wPremi),
    };
  }

  // =========================
  // Compact table (dynamic widths + wrap)
  // =========================

  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsetParCariModel> details,
      bool showColumn,
      ) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    final columnWidths = _compactColumnWidths(context, details, showColumn);

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
                  _tableHeader(context, showColumn),
                  ...details.asMap().entries.map(
                        (e) => _detailRowWithCheckbox(
                      context,
                      e.value,
                      e.key,
                      showColumn,
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
  // Normal table (tetap fixed seperti awal)
  // =========================

  Widget _buildDetailTableNormal(
      BuildContext context,
      List<AsetParCariModel> details,
      bool showColumn,
      ) {
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
            0: widget.readOnly ? const FixedColumnWidth(0) : const FixedColumnWidth(40),
            1: const FixedColumnWidth(50),

            if (showColumn) ...{
              2: const FixedColumnWidth(140),
              3: const FixedColumnWidth(120),
              4: const FixedColumnWidth(170),
              5: const FixedColumnWidth(240),
              6: const FixedColumnWidth(180),
              7: const FixedColumnWidth(170),
              8: const FixedColumnWidth(140),
            } else ...{
              2: const FixedColumnWidth(120),
              3: const FixedColumnWidth(120),
              4: const FixedColumnWidth(240),
              5: const FixedColumnWidth(180),
              6: const FixedColumnWidth(170),
              7: const FixedColumnWidth(140),
            },
          },
          children: [
            _tableHeader(context, showColumn),
            ...details.asMap().entries.map(
                  (e) => _detailRowWithCheckbox(
                context,
                e.value,
                e.key,
                showColumn,
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

  TableRow _tableHeader(BuildContext context, bool showColumn) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        const SizedBox(),
        ...[
          "No",
          if (showColumn) "No Proses",
          "No Polis",
          "Tertanggung",
          "Lokasi",
          "Periode",
          "Nilai Pertanggungan",
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

  // =========================
  // Row
  // =========================

  TableRow _detailRowWithCheckbox(
      BuildContext context,
      AsetParCariModel d,
      int index,
      bool showColumn, {
        required bool compact,
      }) {
    final isSelected = widget.selectedItem == d;

    // ⬇️ ini bagian “baris disesuaikan jadi 2/3 baris”
    // saat compact, kita kasih ruang lebih banyak untuk kolom teks panjang.
    final maxLinesPolis = compact ? 2 : 1;
    final maxLinesTertanggung = compact ? 2 : 1;
    final maxLinesAlamat = compact ? 3 : 1; // alamat paling sering panjang

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
                  widget.onSelect(d.asetParId);
                  widget.onSelectItem?.call(d);

                  if (d.filePolisParId.isNotEmpty) {
                    widget.onSelectFilePolisParId(d.filePolisParId);
                  }
                  if (d.filePolisEqId.isNotEmpty) {
                    widget.onSelectFilePolisEqId(d.filePolisEqId);
                  }
                } else {
                  widget.onUnselect(d.asetParId);
                  widget.onClearSelectedItem?.call();

                  if (d.filePolisParId.isNotEmpty) {
                    widget.onUnselectFilePolisParId(d.filePolisParId);
                  }
                  if (d.filePolisEqId.isNotEmpty) {
                    widget.onUnselectFilePolisEqId(d.filePolisEqId);
                  }
                }
              },
            ),
          )
        else
          const SizedBox(),

        _textCell(d.nomor.toString(), center: true, softWrap: false),

        if (showColumn)
          _textCell(
            d.prosesId.isEmpty ? "-" : d.prosesId,
            maxLines: 1,
            softWrap: false,
          ),

        _textCell(
          d.polisNo,
          maxLines: maxLinesPolis,
          softWrap: true,
        ),

        _textCell(
          d.tertanggung,
          maxLines: maxLinesTertanggung,
          softWrap: true,
        ),

        _textCell(
          d.alamat,
          maxLines: maxLinesAlamat,
          softWrap: true,
        ),

        _textCell(
          "${DateFormat('dd MMM yyyy').format(d.periodeMulai)} - "
              "${DateFormat('dd MMM yyyy').format(d.periodeAkhir)}",
          maxLines: compact ? 2 : 1, // 2 biar kalau sempit dia wrap natural
          softWrap: true,
        ),

        _textCell(
          "${d.curr} ${formatNum(d.sumInsured)}",
          maxLines: 1,
          softWrap: false,
        ),

        _textCell(
          "${d.curr} ${formatNum(d.premi)}",
          maxLines: 1,
          softWrap: false,
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
