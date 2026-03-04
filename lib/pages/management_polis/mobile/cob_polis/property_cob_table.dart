import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
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
  late final ScrollController vController;

  @override
  void initState() {
    super.initState();
    hController = ScrollController();
    vController = ScrollController();
    vController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<AsetParCariBloc>();
    final s = bloc.state;

    if (!vController.hasClients) return;
    final max = vController.position.maxScrollExtent;
    final cur = vController.position.pixels;

    const threshold = 100.0;

    if (max - cur <= threshold) {
      if (!s.hasReachedMax && !s.isFetching) {
        bloc.add(FetchAsetParCariEvent());
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

  List<AsetParCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetParId)).toList();
  }

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
                ? _buildDetailTableCompact(context, items, showColumn)
                : _buildDetailTableNormal(context, items, showColumn),
          ),
          const SizedBox(height: hPadding),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, String cobNama) {
    return Text(
      "Polis $cobNama",
      style: headingStyle(context, fontSize: 14),
    );
  }

  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsetParCariModel> details,
      bool showColumn
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
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(false),
            trackVisibility: WidgetStateProperty.all(false),
            thickness: WidgetStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: WidgetStateProperty.all(
              scrollBar.withOpacity(0.1),
            ),
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
                columnWidths: {
                  0: widget.readOnly
                      ? const FixedColumnWidth(0)
                      : const FixedColumnWidth(40),

                  1: const FixedColumnWidth(50), // No

                  if (showColumn) ...{
                    2: const FixedColumnWidth(140), // No Proses
                    3: const FixedColumnWidth(120), // No Polis
                    4: const FixedColumnWidth(170), // Tertanggung
                    5: const FixedColumnWidth(240), // Alamat
                    6: const FixedColumnWidth(180), // Periode
                    7: const FixedColumnWidth(170), // Nilai Pertanggungan
                    8: const FixedColumnWidth(140), // Premi
                  } else ...{
                    2: const FixedColumnWidth(160), // No Polis
                    3: const FixedColumnWidth(170), // Tertanggung
                    4: const FixedColumnWidth(240), // Alamat
                    5: const FixedColumnWidth(180), // Periode
                    6: const FixedColumnWidth(170), // Nilai Pertanggungan
                    7: const FixedColumnWidth(140), // Premi
                  },
                },
                children: [
                  _tableHeader(context, details, showColumn, compact: true),

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

  Widget _buildDetailTableNormal(BuildContext context, List<AsetParCariModel> details, bool showColumn) {
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
            0: widget.readOnly
                ? const FixedColumnWidth(0)
                : const FixedColumnWidth(40),

            1: const FixedColumnWidth(50), // No

            if (showColumn) ...{
              2: const FixedColumnWidth(140), // No Proses
              3: const FixedColumnWidth(120), // No Polis
              4: const FixedColumnWidth(170), // Tertanggung
              5: const FixedColumnWidth(240), // Alamat
              6: const FixedColumnWidth(180), // Periode
              7: const FixedColumnWidth(170), // Nilai Pertanggungan
              8: const FixedColumnWidth(140), // Premi
            } else ...{
              2: const FixedColumnWidth(120), // No Polis
              3: const FixedColumnWidth(120), // Tertanggung
              4: const FixedColumnWidth(240), // Alamat
              5: const FixedColumnWidth(180), // Periode
              6: const FixedColumnWidth(170), // Nilai Pertanggungan
              7: const FixedColumnWidth(140), // Premi
            },
          },
          children: [
            _tableHeader(context, details, showColumn, compact: false),

            ...details.asMap().entries.map((e) => _detailRowWithCheckbox(
              context,
              e.value,
              e.key,
              showColumn,
              compact: false,
            )),
          ],
        ),
      ),
    );
  }

  TableRow _tableHeader(
      BuildContext context,
      List<AsetParCariModel> details,
      bool showColumn,
      {
        required bool compact,
      }) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        if (!widget.readOnly)
          const SizedBox()
        else
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
          final upper = t.toUpperCase();
          final center = upper == "NO";
          final child = Text(t, style: bodyTextStyle(context, fontSize: 15));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            child: center ? Center(child: child) : child,
          );
        }),
      ],
    );
  }

  TableRow _detailRowWithCheckbox(
      BuildContext context,
      AsetParCariModel d,
      int index,
      bool showColumn,
      {
        required bool compact,
      }) {
    final isSelected = widget.selectedItem == d;

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

        _cell(
          child: Center(
            child: Text(
              d.nomor.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        if (showColumn)
          _cell(
            child: Text(
              d.prosesId.isEmpty ? "-" : d.prosesId,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),

        _cell(
          child: Text(
            d.polisNo,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            d.tertanggung,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            d.alamat,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            "${DateFormat('dd MMM yyyy').format(d.periodeMulai)} -\n"
                "${DateFormat('dd MMM yyyy').format(d.periodeAkhir)}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            "${d.curr} ${formatNum(d.sumInsured)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            "${d.curr} ${formatNum(d.premi)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: primaryLightColor),
          ),
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