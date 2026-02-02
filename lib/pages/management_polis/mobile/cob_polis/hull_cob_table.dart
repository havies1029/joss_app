// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../common/constants.dart';
// import '../../../../models/gen_aset_hull/asethullcari_model.dart';
//
//
// class HullCobTable extends StatefulWidget {
//   final List<AsethullCariModel> items;
//   final List<String> selectedIds;
//   final Function(String id) onSelect;
//   final Function(String id) onUnselect;
//
//   final Function(String id) onSelectFilePolisHullId;
//   final Function(String id) onUnselectFilePolisHullId;
//
//   final bool readOnly;
//   final bool showFooter;
//   final String? title;
//
//   const HullCobTable({
//     super.key,
//     required this.items,
//     required this.selectedIds,
//     required this.onSelect,
//     required this.onUnselect,
//     required this.onSelectFilePolisHullId,
//     required this.onUnselectFilePolisHullId,
//     this.readOnly = false,
//     this.showFooter = true,
//     this.title,
//   });
//
//   @override
//   State<HullCobTable> createState() => _HullCobTableState();
// }
//
// class _HullCobTableState extends State<HullCobTable> {
//   String formatNum(num value) => NumberFormat.decimalPattern().format(value);
//   late final ScrollController hController;
//
//   @override
//   void initState() {
//     super.initState();
//     hController = ScrollController();
//   }
//
//   @override
//   void dispose() {
//     hController.dispose();
//     super.dispose();
//   }
//
//   bool _isAllSelected(List<AsethullCariModel> details) {
//     if (details.isEmpty) return false;
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => selected.contains(d.asetHullId));
//   }
//
//   bool _isNoneSelected(List<AsethullCariModel> details) {
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => !selected.contains(d.asetHullId));
//   }
//
//   void _toggleSelectAll(bool checked, List<AsethullCariModel> details) {
//     for (final d in details) {
//       final id = d.asetHullId;
//       if (id.isEmpty) continue;
//
//       if (checked) {
//         if (!widget.selectedIds.contains(id)) {
//           widget.onSelect(id);
//           if (d.filePolisId.isNotEmpty) {
//             widget.onSelectFilePolisHullId(d.filePolisId);
//           }
//         }
//       } else {
//         if (widget.selectedIds.contains(id)) {
//           widget.onUnselect(id);
//           if (d.filePolisId.isNotEmpty) {
//             widget.onUnselectFilePolisHullId(d.filePolisId);
//           }
//         }
//       }
//     }
//   }
//
//
//   List<AsethullCariModel> get _filteredItems {
//     if (!widget.readOnly) return widget.items;
//     return widget.items.where((d) => widget.selectedIds.contains(d.asetHullId)).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool isNarrow = width < 900;
//
//     final items = _filteredItems;
//
//     if (items.isEmpty) {
//       return const Center(child: Text("Data kosong"));
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.title != null) ...[
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//               child: Text(widget.title!, style: headingStyle(context, fontSize: 14)),
//             ),
//             const SizedBox(height: hPadding),
//           ],
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//             child: isNarrow
//                 ? _buildDetailTableCompact(context, items)
//                 : _buildDetailTableNormal(context, items),
//           ),
//           const SizedBox(height: hPadding),
//         ],
//       ),
//     );
//
//   }
//
//   Widget _buildHeaderTitle(BuildContext context, String cobNama) {
//     return Text(
//       "Polis $cobNama",
//       style: headingStyle(context, fontSize: 14),
//     );
//   }
//
//   Widget _buildDetailTableCompact(
//       BuildContext context,
//       List<AsethullCariModel> details,
//       ) {
//     if (details.isEmpty) return const Text("Tidak ada detail polis");
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(cardBorderRadius),
//       child: Container(
//         decoration: BoxDecoration(
//           color: formGrey,
//           borderRadius: BorderRadius.circular(cardBorderRadius),
//           border: const Border(
//             top: BorderSide(color: sGrey, width: 1),
//             left: BorderSide(color: sGrey, width: 1),
//             right: BorderSide(color: sGrey, width: 1),
//             bottom: BorderSide(color: sGrey, width: 1),
//           ),
//         ),
//         child: ScrollbarTheme(
//           data: ScrollbarThemeData(
//             thumbVisibility: MaterialStateProperty.all(true),
//             trackVisibility: MaterialStateProperty.all(false),
//             thickness: MaterialStateProperty.all(5),
//             radius: const Radius.circular(cardBorderRadius),
//             thumbColor: MaterialStateProperty.all(
//               scrollBar.withOpacity(0.1),
//             ),
//           ),
//           child: Scrollbar(
//             controller: hController,
//             child: SingleChildScrollView(
//               controller: hController,
//               scrollDirection: Axis.horizontal,
//               child: Table(
//                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                 border: const TableBorder(
//                   horizontalInside: BorderSide(color: sGrey, width: 1),
//                   verticalInside: BorderSide(color: sGrey, width: 1),
//                 ),
//                 columnWidths: {
//                   0: widget.readOnly
//                       ? const FixedColumnWidth(0)
//                       : const FixedColumnWidth(40), // checkbox
//                   1: const FixedColumnWidth(50),  // No
//                   2: const FixedColumnWidth(190), // Tertanggung
//                   3: const FixedColumnWidth(290), // Detail Rangka Kapal
//                   4: const FixedColumnWidth(210), // Nilai Tertanggung
//                   5: const FixedColumnWidth(130), // Premi
//                 },
//                 children: [
//                   _tableHeaderWithSelectAll(context, details),
//                   ...details.asMap().entries.map(
//                         (e) => _detailRowWithCheckbox(
//                       context,
//                       e.value,
//                       e.key,
//                       compact: true,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailTableNormal(BuildContext context, List<AsethullCariModel> details) {
//     if (details.isEmpty) return const Text("Tidak ada detail polis");
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(cardBorderRadius),
//       child: Container(
//         decoration: BoxDecoration(
//           color: formGrey,
//           borderRadius: BorderRadius.circular(cardBorderRadius),
//           border: const Border(
//             top: BorderSide(color: sGrey, width: 1),
//             left: BorderSide(color: sGrey, width: 1),
//             right: BorderSide(color: sGrey, width: 1),
//             bottom: BorderSide(color: sGrey, width: 1),
//           ),
//         ),
//         child: Table(
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           border: const TableBorder(
//             horizontalInside: BorderSide(color: sGrey, width: 1),
//             verticalInside: BorderSide(color: sGrey, width: 1),
//           ),
//           columnWidths: {
//             0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8), // checkbox
//             1: const FlexColumnWidth(1.0),   // No
//             2: const FlexColumnWidth(2.6),   // Tertanggung
//             3: const FlexColumnWidth(3.7),   // Detail Rangka Kapal
//             4: const FlexColumnWidth(2.7),   // Nilai Tertanggung
//             5: const FlexColumnWidth(1.6),   // Premi
//             // 6: const FlexColumnWidth(1.4), // Status
//           },
//           children: [
//             _tableHeaderWithSelectAll(context, details),
//             ...details.asMap().entries.map((e) => _detailRowWithCheckbox(
//               context,
//               e.value,
//               e.key,
//               compact: false,
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   TableRow _tableHeaderWithSelectAll(
//       BuildContext context,
//       List<AsethullCariModel> details,
//       ) {
//     if (widget.readOnly) {
//       return _tableHeader(context, [
//         "",
//         "No",
//         "Tertanggung",
//         "Detail Rangka Kapal",
//         "Nilai Tertanggung",
//         "Premi",
//       ]);
//     }
//
//     final allSelected = _isAllSelected(details);
//     final noneSelected = _isNoneSelected(details);
//
//     return TableRow(
//       decoration: const BoxDecoration(color: formGrey),
//       children: [
//         Center(
//           child: Checkbox(
//             value: allSelected ? true : (noneSelected ? false : null),
//             tristate: true,
//             onChanged: (_) {
//               // sama persis kayak MV: minus/false -> select all, true -> unselect all
//               final checked = !_isAllSelected(details);
//               _toggleSelectAll(checked, details);
//             },
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(cardBorderRadius / 2),
//             ),
//             side: MaterialStateBorderSide.resolveWith(
//                   (states) => const BorderSide(color: sGrey),
//             ),
//             fillColor: MaterialStateProperty.resolveWith(
//                   (states) => states.contains(MaterialState.selected)
//                   ? primaryColor
//                   : Colors.transparent,
//             ),
//             checkColor: primaryLightColor,
//           ),
//         ),
//         ...[
//           "No",
//           "Tertanggung",
//           "Detail Rangka Kapal",
//           "Nilai Tertanggung",
//           "Premi",
//         ].map((t) {
//           final upper = t.toUpperCase();
//           final center = upper == "NO";
//           final child = Text(t, style: bodyTextStyle(context, fontSize: 15));
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
//             child: center ? Center(child: child) : child,
//           );
//         }).toList(),
//       ],
//     );
//   }
//
//   TableRow _tableHeader(BuildContext context, List<String> cells) {
//     return TableRow(
//       decoration: const BoxDecoration(color: formGrey),
//       children: cells.map((text) {
//         final upper = text.trim().toUpperCase();
//         final bool center = (upper == "NO" || upper == "STATUS" || text.trim().isEmpty);
//
//         final child = Text(text, style: bodyTextStyle(context, fontSize: 15));
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
//           child: center ? Center(child: child) : child,
//         );
//       }).toList(),
//     );
//   }
//
//   TableRow _detailRowWithCheckbox(
//       BuildContext context,
//       AsethullCariModel d,
//       int index, {
//         required bool compact,
//       }) {
//     final isSelected = widget.selectedIds.contains(d.asetHullId);
//
//     return TableRow(
//       decoration: BoxDecoration(
//         color: (!widget.readOnly && isSelected)
//             ? primaryColor.withOpacity(0.3)
//             : (index.isEven ? pGrey : formGrey),
//       ),
//       children: [
//         // checkbox (tetap sama seperti tabel kamu sebelumnya)
//         if (!widget.readOnly) ...[
//           Center(
//             child: Checkbox(
//               value: isSelected,
//               onChanged: (checked) {
//                 if (checked == true) {
//                   widget.onSelect(d.asetHullId);
//                   if (d.filePolisId.isNotEmpty) {
//                     widget.onSelectFilePolisHullId(d.filePolisId);
//                   }
//                 } else {
//                   widget.onUnselect(d.asetHullId);
//                   if (d.filePolisId.isNotEmpty) {
//                     widget.onUnselectFilePolisHullId(d.filePolisId);
//                   }
//                 }
//               },
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(cardBorderRadius / 2),
//               ),
//               side: MaterialStateBorderSide.resolveWith(
//                     (states) => const BorderSide(color: sGrey),
//               ),
//               fillColor: MaterialStateProperty.resolveWith(
//                     (states) => states.contains(MaterialState.selected)
//                     ? primaryColor
//                     : Colors.transparent,
//               ),
//               checkColor: primaryLightColor,
//             ),
//           ),
//         ] else ...[
//           const SizedBox(),
//         ],
//
//         // No
//         _cell(
//           child: Center(
//             child: Text(
//               (index + 1).toString(),
//               style: TextStyle(color: primaryLightColor),
//             ),
//           ),
//         ),
//
//         // Tertanggung
//         _cell(
//           child: Text(
//             d.tertanggung,
//             maxLines: compact ? 2 : 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         // Detail Rangka Kapal (pakai namaKapal)
//         _cell(
//           child: Text(
//             d.namaKapal,
//             maxLines: compact ? 2 : 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         // Nilai Tertanggung (TSI)
//         _cell(
//           child: Text(
//             formatNum(d.tsi),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         // Premi
//         _cell(
//           child: Text(
//             formatNum(d.premi),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         // Status
//         // _cell(
//         //   child: Center(
//         //     child: Text(
//         //       d.status,
//         //       maxLines: 1,
//         //       overflow: TextOverflow.ellipsis,
//         //       style: TextStyle(color: primaryLightColor),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
//
//   Widget _cell({required Widget child}) {
//     return Padding(
//       padding: const EdgeInsets.all(6),
//       child: child,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_aset_hull/asethullcari_model.dart';


class HullCobTable extends StatefulWidget {
  final List<AsethullCariModel> items;
  final List<String> selectedIds;
  final void Function(AsethullCariModel item)? onSelectItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisHullId;
  final Function(String id) onUnselectFilePolisHullId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const HullCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisHullId,
    required this.onUnselectFilePolisHullId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<HullCobTable> createState() => _HullCobTableState();
}

class _HullCobTableState extends State<HullCobTable> {
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

  Widget _buildDetailTableCompact(
      BuildContext context,
      List<AsethullCariModel> details,
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
            thumbVisibility: MaterialStateProperty.all(true),
            trackVisibility: MaterialStateProperty.all(false),
            thickness: MaterialStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: MaterialStateProperty.all(
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
                      : const FixedColumnWidth(40), // radio button
                  1: const FixedColumnWidth(50),  // No
                  2: const FixedColumnWidth(190), // Tertanggung
                  3: const FixedColumnWidth(290), // Detail Rangka Kapal
                  4: const FixedColumnWidth(210), // Nilai Tertanggung
                  5: const FixedColumnWidth(130), // Premi
                },
                children: [
                  _tableHeader(context, details),
                  ...details.asMap().entries.map(
                        (e) => _detailRowWithRadio(
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
            0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8), // radio button
            1: const FlexColumnWidth(1.0),   // No
            2: const FlexColumnWidth(2.6),   // Tertanggung
            3: const FlexColumnWidth(3.7),   // Detail Rangka Kapal
            4: const FlexColumnWidth(2.7),   // Nilai Tertanggung
            5: const FlexColumnWidth(1.6),   // Premi
          },
          children: [
            _tableHeader(context, details),
            ...details.asMap().entries.map((e) => _detailRowWithRadio(
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

  TableRow _tableHeader(
      BuildContext context,
      List<AsethullCariModel> details,
      ) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: [
        if (!widget.readOnly)
          const SizedBox() // kosong untuk kolom radio button
        else
          const SizedBox(),
        ...[
          "No",
          "Tertanggung",
          "Detail Rangka Kapal",
          "Nilai Tertanggung",
          "Premi",
        ].map((t) {
          final upper = t.toUpperCase();
          final center = upper == "NO";
          final child = Text(t, style: bodyTextStyle(context, fontSize: 15));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            child: center ? Center(child: child) : child,
          );
        }).toList(),
      ],
    );
  }

  TableRow _detailRowWithRadio(
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
        if (!widget.readOnly)
          Center(
            child: RadioButton(
              isSelected: isSelected,
              onTap: () {
                // Unselect semua item yang sedang terpilih (kecuali yang diklik)
                for (final item in widget.items) {
                  if (widget.selectedIds.contains(item.asetHullId) && item.asetHullId != d.asetHullId) {
                    widget.onUnselect(item.asetHullId);
                    if (item.filePolisId.isNotEmpty) {
                      widget.onUnselectFilePolisHullId(item.filePolisId);
                    }
                  }
                }

                // Kemudian select item yang baru diklik
                widget.onSelect(d.asetHullId);

                widget.onSelectItem?.call(d); //ini coy

                if (d.filePolisId.isNotEmpty) {
                  widget.onSelectFilePolisHullId(d.filePolisId);
                }
              },
            ),
          )
        else
          const SizedBox(),

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