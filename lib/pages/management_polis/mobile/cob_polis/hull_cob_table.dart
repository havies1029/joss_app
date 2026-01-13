import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_aset_hull/asethullcari_model.dart';


class HullCobTable extends StatefulWidget {
  final List<AsethullCariModel> items;
  final List<String> selectedIds;
  final Function(String id) onSelect;
  final Function(String id) onUnselect;
  final bool readOnly;
  final bool showFooter; // tetap ada biar kompatibel, tapi tidak dipakai
  final String? title;   // optional kalau mau judul

  const HullCobTable({
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
  State<HullCobTable> createState() => _HullCobTableState();
}

class _HullCobTableState extends State<HullCobTable> {
  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  List<AsethullCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asetHullId)).toList();
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

  Widget _buildDetailTableCompact(BuildContext context, List<AsethullCariModel> details) {
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
              3: const FixedColumnWidth(240), // Detail Rangka Kapal
              4: const FixedColumnWidth(170), // Nilai Tertanggung
              5: const FixedColumnWidth(130), // Premi
              6: const FixedColumnWidth(110), // Status
            },
            children: [
              _tableHeader(context, [
                "",
                "No",
                "Tertanggung",
                "Detail Rangka Kapal",
                "Nilai Tertanggung",
                "Premi",
                "Status",
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

  Widget _buildDetailTableNormal(BuildContext context, List<AsethullCariModel> details) {
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
            0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8), // checkbox
            1: const FlexColumnWidth(1),   // No
            2: const FlexColumnWidth(2.4), // Tertanggung
            3: const FlexColumnWidth(3.0), // Detail Rangka Kapal (namaKapal / detail)
            4: const FlexColumnWidth(2.2), // Nilai Tertanggung (tsi)
            5: const FlexColumnWidth(1.6), // Premi
            6: const FlexColumnWidth(1.4), // Status
          },
          children: [
            _tableHeader(context, [
              "",
              "No",
              "Tertanggung",
              "Detail Rangka Kapal",
              "Nilai Tertanggung",
              "Premi",
              "Status",
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
      AsethullCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(d.asetHullId);

    return TableRow(
      decoration: BoxDecoration(
        color: (!widget.readOnly && isSelected)
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        // checkbox (tetap sama seperti tabel kamu sebelumnya)
        if (!widget.readOnly) ...[
          Center(
            child: Checkbox(
              value: isSelected,
              onChanged: (checked) {
                if (checked == true) {
                  widget.onSelect(d.asetHullId);
                } else {
                  widget.onUnselect(d.asetHullId);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius / 2),
              ),
              side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: sGrey),
              ),
              fillColor: MaterialStateProperty.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? primaryColor
                    : Colors.transparent,
              ),
              checkColor: primaryLightColor,
            ),
          ),
        ] else ...[
          const SizedBox(),
        ],

        // No
        _cell(
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Tertanggung
        _cell(
          child: Text(
            d.tertanggung,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Detail Rangka Kapal (pakai namaKapal)
        _cell(
          child: Text(
            d.namaKapal,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Nilai Tertanggung (TSI)
        _cell(
          child: Text(
            formatNum(d.tsi),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Premi
        _cell(
          child: Text(
            formatNum(d.premi),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Status
        _cell(
          child: Center(
            child: Text(
              d.status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
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
