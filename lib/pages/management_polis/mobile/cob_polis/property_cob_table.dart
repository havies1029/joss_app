import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_aset_par/asetparcari_model.dart';

class PropertyCobTable extends StatefulWidget {
  final List<AsetParCariModel> items;
  final List<String> selectedIds;
  final Function(String id) onSelect;
  final Function(String id) onUnselect;
  final bool readOnly;
  final bool showFooter;
  final String? title;

  const PropertyCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelect,
    required this.onUnselect,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<PropertyCobTable> createState() => _PropertyCobTableState();
}

class _PropertyCobTableState extends State<PropertyCobTable> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  List<AsetParCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetParId)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

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
                ? _buildDetailTableCompact(context, items)
                : _buildDetailTableNormal(context, items),
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

  Widget _buildDetailTableCompact(BuildContext context, List<AsetParCariModel> details) {
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: const TableBorder(
              horizontalInside: BorderSide(color: sGrey, width: 1),
              verticalInside: BorderSide(color: sGrey, width: 1),
            ),
            columnWidths: {
              0: widget.readOnly ? const FixedColumnWidth(0) : const FixedColumnWidth(40), // checkbox
              1: const FixedColumnWidth(50),  // No
              2: const FixedColumnWidth(170), // Tertanggung
              3: const FixedColumnWidth(240), // Alamat (+20)
              4: const FixedColumnWidth(145), // Periode Mulai (disamain)
              5: const FixedColumnWidth(145), // Periode Akhir (disamain)
              6: const FixedColumnWidth(150), // Nilai Pertanggungan (+20)
              7: const FixedColumnWidth(110), // Premi
            },
            children: [
              _tableHeader(context, [
                "",
                "No",
                "Tertanggung",
                "Alamat",
                "Periode Mulai",
                "Periode Akhir",
                "Nilai Pertanggungan",
                "Premi",
                // "Status",
              ]),
              ...details.asMap().entries.map((e) => _detailRowWithCheckbox(
                context,
                e.value,
                e.key,
                compact: true,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTableNormal(BuildContext context, List<AsetParCariModel> details) {
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
                : const FlexColumnWidth(0.8), // checkbox
            1: const FlexColumnWidth(1.0),   // No
            2: const FlexColumnWidth(2.2),   // Tertanggung
            3: const FlexColumnWidth(3.3),   // Alamat (+0.3)
            4: const FlexColumnWidth(1.7),   // Periode Mulai (disamain & dikecilin)
            5: const FlexColumnWidth(1.7),   // Periode Akhir (disamain)
            6: const FlexColumnWidth(1.8),   // Nilai Pertanggungan (+0.2)
            7: const FlexColumnWidth(1.4),   // Premi
          },
          children: [
            _tableHeader(context, [
              "",
              "No",
              "Tertanggung",
              "Alamat",
              "Periode Mulai",
              "Periode Akhir",
              "Nilai Pertanggungan",
              "Premi",
              // "Status",
            ]),
            ...details.asMap().entries.map((e) => _detailRowWithCheckbox(
              context,
              e.value,
              e.key,
              compact: false,
            )),
          ],
        ),
      ),
    );
  }

  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: cells.map((text) {
        final upper = text.trim().toUpperCase();
        final bool center = (upper == "NO" || upper == "STATUS" || text.trim().isEmpty);

        final child = Text(text, style: bodyTextStyle(context, fontSize: 15));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
          child: center ? Center(child: child) : child,
        );
      }).toList(),
    );
  }

  TableRow _detailRowWithCheckbox(
      BuildContext context,
      AsetParCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(d.asetParId);

    return TableRow(
      decoration: BoxDecoration(
        color: (!widget.readOnly && isSelected)
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        if (!widget.readOnly)
          Center(
            child: Checkbox(
              value: isSelected,
              onChanged: (checked) {
                if (checked == true) {
                  widget.onSelect(d.asetParId);
                } else {
                  widget.onUnselect(d.asetParId);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius / 2),
              ),
              side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: sGrey),
              ),
              fillColor: MaterialStateProperty.resolveWith(
                    (states) =>
                states.contains(MaterialState.selected) ? primaryColor : Colors.transparent,
              ),
              checkColor: primaryLightColor,
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

        // Periode Mulai
        _cell(
          child: Text(
            "${d.periodeMulai}",
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Periode Akhir
        _cell(
          child: Text(
            "${d.periodeAkhir}",
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),


        _cell(
          child: Text(
            formatNum(d.sumInsured),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            formatNum(d.premi),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // _cell(
        //   child: Center(
        //     child: Text(
        //       d.status,
        //       maxLines: 1,
        //       overflow: TextOverflow.ellipsis,
        //       style: TextStyle(color: primaryLightColor),
        //     ),
        //   ),
        // ),
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
