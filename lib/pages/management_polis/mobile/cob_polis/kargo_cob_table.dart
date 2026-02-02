// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../common/constants.dart';
// import '../../../../models/asetothers/asetotherscari_model.dart';
//
// class KargoCobTable extends StatefulWidget {
//   final List<AsetothersCariModel> items;
//   final List<String> selectedIds;
//   final Function(String id) onSelect;
//   final Function(String id) onUnselect;
//
//   final Function(String id) onSelectFilePolisHealthId;
//   final Function(String id) onUnselectFilePolisHealthId;
//
//   final bool readOnly;
//   final bool showFooter;
//   final String? title;
//
//   const KargoCobTable({
//     super.key,
//     required this.items,
//     required this.selectedIds,
//     required this.onSelect,
//     required this.onUnselect,
//     required this.onSelectFilePolisHealthId,
//     required this.onUnselectFilePolisHealthId,
//     this.readOnly = false,
//     this.showFooter = true,
//     this.title,
//   });
//
//   @override
//   State<KargoCobTable> createState() => _KargoCobTableState();
// }
//
// class _KargoCobTableState extends State<KargoCobTable> {
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
//   bool _isAllSelected(List<AsetothersCariModel> details) {
//     if (details.isEmpty) return false;
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => selected.contains(d.asetOthersId));
//   }
//
//   bool _isNoneSelected(List<AsetothersCariModel> details) {
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => !selected.contains(d.asetOthersId));
//   }
//
//   void _toggleSelectAll(bool checked, List<AsetothersCariModel> details) {
//     for (final d in details) {
//       final id = d.asetOthersId;
//       if (id.isEmpty) continue;
//
//       if (checked) {
//         if (!widget.selectedIds.contains(id)) {
//           widget.onSelect(id);
//           if (d.filePolisId.isNotEmpty) {
//             widget.onSelectFilePolisHealthId(d.filePolisId);
//           }
//         }
//       } else {
//         if (widget.selectedIds.contains(id)) {
//           widget.onUnselect(id);
//           if (d.filePolisId.isNotEmpty) {
//             widget.onUnselectFilePolisHealthId(d.filePolisId);
//           }
//         }
//       }
//     }
//   }
//
//
//   List<AsetothersCariModel> get _filteredItems {
//     if (!widget.readOnly) return widget.items;
//     return widget.items
//         .where((d) => widget.selectedIds.contains(d.asetOthersId))
//         .toList();
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
//   }
//
//   Widget _buildDetailTableCompact(
//       BuildContext context,
//       List<AsetothersCariModel> details,
//       ) {
//     if (details.isEmpty) return const Text("Tidak ada detail");
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
//                   2: const FixedColumnWidth(310), // Object Desc
//                   3: const FixedColumnWidth(180), // Polis No
//                   4: const FixedColumnWidth(80),  // Curr
//                   5: const FixedColumnWidth(200), // Sum Insured
//                   6: const FixedColumnWidth(140), // Premi
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
//
//   Widget _buildDetailTableNormal(
//       BuildContext context, List<AsetothersCariModel> details) {
//     if (details.isEmpty) return const Text("Tidak ada detail");
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
//             2: const FlexColumnWidth(3.6),   // Object Desc
//             3: const FlexColumnWidth(2.3),   // Polis No
//             4: const FlexColumnWidth(1.0),   // Curr
//             5: const FlexColumnWidth(2.7),   // Sum Insured
//             6: const FlexColumnWidth(1.6),   // Premi
//             // 7: const FlexColumnWidth(1.4), // Status
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
//       List<AsetothersCariModel> details,
//       ) {
//     if (widget.readOnly) {
//       return _tableHeader(context, [
//         "",
//         "No",
//         "Object",
//         "Polis No",
//         "Curr",
//         "Sum Insured",
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
//               // sama persis: false/null => select all, true => unselect all
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
//           "Object",
//           "Polis No",
//           "Curr",
//           "Sum Insured",
//           "Premi",
//         ].map((t) {
//           final upper = t.trim().toUpperCase();
//           final center = (upper == "NO" ||
//               upper == "CURR" ||
//               upper == "PREMI" ||
//               upper == "SUM INSURED");
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
//         final bool center = (upper == "NO" ||
//             upper == "STATUS" ||
//             upper == "CURR" ||
//             upper == "PREMI" ||
//             upper == "SUM INSURED" ||
//             text.trim().isEmpty);
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
//       AsetothersCariModel d,
//       int index, {
//         required bool compact,
//       }) {
//     final isSelected = widget.selectedIds.contains(d.asetOthersId);
//
//     return TableRow(
//       decoration: BoxDecoration(
//         color: (!widget.readOnly && isSelected)
//             ? primaryColor.withOpacity(0.3)
//             : (index.isEven ? pGrey : formGrey),
//       ),
//       children: [
//         if (!widget.readOnly)
//           Center(
//             child: Checkbox(
//               value: isSelected,
//               onChanged: (checked) {
//                 if (checked == true) {
//                   widget.onSelect(d.asetOthersId);
//                   if (d.filePolisId.isNotEmpty) {
//                     widget.onSelectFilePolisHealthId(d.filePolisId);
//                   }
//                 } else {
//                   widget.onUnselect(d.asetOthersId);
//                   if (d.filePolisId.isNotEmpty) {
//                     widget.onUnselectFilePolisHealthId(d.filePolisId);
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
//           )
//         else
//           const SizedBox(),
//
//         _cell(
//           child: Center(
//             child: Text(
//               d.nomor.toString(),
//               style: TextStyle(color: primaryLightColor),
//             ),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             d.objectDesc,
//             maxLines: compact ? 2 : 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             d.polisNo,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         _cell(
//           child: Center(
//             child: Text(
//               d.curr,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(color: primaryLightColor),
//             ),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             formatNum(d.sumInsured),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             formatNum(d.premi),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
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
import '../../../../models/asetothers/asetotherscari_model.dart';

class KargoCobTable extends StatefulWidget {
  final List<AsetothersCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetothersCariModel item)? onSelectItem;

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
    required this.onSelectItem,
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

  List<AsetothersCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items
        .where((d) => widget.selectedIds.contains(d.asetOthersId))
        .toList();
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

  Widget _buildDetailTableCompact(
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
                  2: const FixedColumnWidth(310), // Object Desc
                  3: const FixedColumnWidth(180), // Polis No
                  4: const FixedColumnWidth(80),  // Curr
                  5: const FixedColumnWidth(200), // Sum Insured
                  6: const FixedColumnWidth(140), // Premi
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


  Widget _buildDetailTableNormal(
      BuildContext context, List<AsetothersCariModel> details) {
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
            0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8), // radio button
            1: const FlexColumnWidth(1.0),   // No
            2: const FlexColumnWidth(3.6),   // Object Desc
            3: const FlexColumnWidth(2.3),   // Polis No
            4: const FlexColumnWidth(1.0),   // Curr
            5: const FlexColumnWidth(2.7),   // Sum Insured
            6: const FlexColumnWidth(1.6),   // Premi
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
      List<AsetothersCariModel> details,
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
          "Object",
          "Polis No",
          "Curr",
          "Sum Insured",
          "Premi",
        ].map((t) {
          final upper = t.trim().toUpperCase();
          final center = (upper == "NO" ||
              upper == "CURR" ||
              upper == "PREMI" ||
              upper == "SUM INSURED");
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
      AsetothersCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(d.asetOthersId);

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
                  if (widget.selectedIds.contains(item.asetOthersId) && item.asetOthersId != d.asetOthersId) {
                    widget.onUnselect(item.asetOthersId);
                    if (item.filePolisId.isNotEmpty) {
                      widget.onUnselectFilePolisHealthId(item.filePolisId);
                    }
                  }
                }

                // Kemudian select item yang baru diklik
                widget.onSelect(d.asetOthersId);

                widget.onSelectItem?.call(d);

                if (d.filePolisId.isNotEmpty) {
                  widget.onSelectFilePolisHealthId(d.filePolisId);
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

        _cell(
          child: Text(
            d.objectDesc,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Text(
            d.polisNo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _cell(
          child: Center(
            child: Text(
              d.curr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
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