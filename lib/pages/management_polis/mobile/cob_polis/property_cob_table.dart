// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../common/constants.dart';
// import '../../../../models/gen_aset_par/asetparcari_model.dart';
//
// class PropertyCobTable extends StatefulWidget {
//   final List<AsetParCariModel> items;
//   final List<String> selectedIds;
//   final Function(String id) onSelect;
//   final Function(String id) onUnselect;
//
//   final Function(String id) onSelectFilePolisParId;
//   final Function(String id) onUnselectFilePolisParId;
//
//   final Function(String id) onSelectFilePolisEqId;
//   final Function(String id) onUnselectFilePolisEqId;
//
//   final bool readOnly;
//   final bool showFooter;
//   final String? title;
//
//   const PropertyCobTable({
//     super.key,
//     required this.items,
//     required this.selectedIds,
//     required this.onSelect,
//     required this.onUnselect,
//     required this.onSelectFilePolisParId,
//     required this.onUnselectFilePolisParId,
//     required this.onSelectFilePolisEqId,
//     required this.onUnselectFilePolisEqId,
//     this.readOnly = false,
//     this.showFooter = true,
//     this.title,
//   });
//
//   @override
//   State<PropertyCobTable> createState() => _PropertyCobTableState();
// }
//
// class _PropertyCobTableState extends State<PropertyCobTable> {
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
//   bool _isAllSelected(List<AsetParCariModel> details) {
//     if (details.isEmpty) return false;
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => selected.contains(d.asetParId));
//   }
//
//   bool _isNoneSelected(List<AsetParCariModel> details) {
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => !selected.contains(d.asetParId));
//   }
//
//   void _toggleSelectAll(bool checked, List<AsetParCariModel> details) {
//     for (final d in details) {
//       final id = d.asetParId;
//       if (id.isEmpty) continue;
//
//       if (checked) {
//         // select hanya yang belum kepilih (biar gak spam event)
//         if (!widget.selectedIds.contains(id)) {
//           widget.onSelect(id);
//           if (d.filePolisParId.isNotEmpty) widget.onSelectFilePolisParId(d.filePolisParId);
//           if (d.filePolisEqId.isNotEmpty) widget.onSelectFilePolisEqId(d.filePolisEqId);
//         }
//       } else {
//         // unselect hanya yang memang kepilih
//         if (widget.selectedIds.contains(id)) {
//           widget.onUnselect(id);
//           if (d.filePolisParId.isNotEmpty) widget.onUnselectFilePolisParId(d.filePolisParId);
//           if (d.filePolisEqId.isNotEmpty) widget.onUnselectFilePolisEqId(d.filePolisEqId);
//         }
//       }
//     }
//   }
//
//   List<AsetParCariModel> get _filteredItems {
//     if (!widget.readOnly) return widget.items;
//     return widget.items.where((d) => widget.selectedIds.contains(d.asetParId)).toList();
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
//       List<AsetParCariModel> details,
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
//                   2: const FixedColumnWidth(170), // Tertanggung
//                   3: const FixedColumnWidth(240), // Alamat
//                   4: const FixedColumnWidth(180), // Periode (gabungan)
//                   5: const FixedColumnWidth(170), // Nilai Pertanggungan (curr + nilai)
//                   6: const FixedColumnWidth(140), // Premi (curr + premi)
//                 },
//                 children: [
//                   _tableHeaderWithSelectAll(context, details, compact: true),
//
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
//   Widget _buildDetailTableNormal(BuildContext context, List<AsetParCariModel> details) {
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
//             0: widget.readOnly
//                 ? const FixedColumnWidth(0)
//                 : const FlexColumnWidth(0.8), // checkbox
//             1: const FlexColumnWidth(1.0),   // No
//             2: const FlexColumnWidth(2.2),   // Tertanggung
//             3: const FlexColumnWidth(3.3),   // Alamat
//             4: const FlexColumnWidth(2.0),   // Periode (gabungan)
//             5: const FlexColumnWidth(2.0),   // Nilai Pertanggungan
//             6: const FlexColumnWidth(1.6),   // Premi
//           },
//           children: [
//             _tableHeaderWithSelectAll(context, details, compact: false),
//
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
//       List<AsetParCariModel> details, {
//         required bool compact,
//       }) {
//     if (widget.readOnly) {
//       return _tableHeader(context, [
//         "",
//         "No",
//         "Tertanggung",
//         "Lokasi",
//         "Periode",
//         "Nilai Pertanggungan",
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
//             // onChanged: (val) {
//             //   // kalau posisi "minus" (null) diklik -> treat jadi select all
//             //   final checked = val ?? false;
//             //   _toggleSelectAll(checked, details);
//             // },
//             onChanged: (_) {
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
//                   (states) => states.contains(MaterialState.selected) ? primaryColor : Colors.transparent,
//             ),
//             checkColor: primaryLightColor,
//           ),
//         ),
//         ...[
//           "No",
//           "Tertanggung",
//           "Lokasi",
//           "Periode",
//           "Nilai Pertanggungan",
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
//       AsetParCariModel d,
//       int index, {
//         required bool compact,
//       }) {
//     final isSelected = widget.selectedIds.contains(d.asetParId);
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
//                   widget.onSelect(d.asetParId);
//                   if (d.filePolisParId.isNotEmpty) {
//                     widget.onSelectFilePolisParId(d.filePolisParId);
//                   }
//                   if (d.filePolisEqId.isNotEmpty) {
//                     widget.onSelectFilePolisEqId(d.filePolisEqId);
//                   }
//                 } else {
//                   widget.onUnselect(d.asetParId);
//                   if (d.filePolisParId.isNotEmpty) {
//                     widget.onUnselectFilePolisParId(d.filePolisParId);
//                   }
//                   if (d.filePolisEqId.isNotEmpty) {
//                     widget.onUnselectFilePolisEqId(d.filePolisEqId);
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
//                     (states) =>
//                 states.contains(MaterialState.selected) ? primaryColor : Colors.transparent,
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
//             d.tertanggung,
//             maxLines: compact ? 2 : 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             d.alamat,
//             maxLines: compact ? 2 : 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         // Periode Mulai
//         _cell(
//           child: Text(
//             "${d.periodeMulai} -\n${d.periodeAkhir}",
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: primaryLightColor),
//           ),
//         ),
//
//         _cell(
//           child: Text(
//             "${d.curr} ${formatNum(d.sumInsured)}",
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: primaryLightColor),
//           ),
//         ),
//         _cell(
//           child: Text(
//             "${d.curr} ${formatNum(d.premi)}",
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: primaryLightColor),
//           ),
//         ),
//
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
import '../../../../models/gen_aset_par/asetparcari_model.dart';

class PropertyCobTable extends StatefulWidget {
  final List<AsetParCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetParCariModel item)? onSelectItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisParId;
  final Function(String id) onUnselectFilePolisParId;

  final Function(String id) onSelectFilePolisEqId;
  final Function(String id) onUnselectFilePolisEqId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const PropertyCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisParId,
    required this.onUnselectFilePolisParId,
    required this.onSelectFilePolisEqId,
    required this.onUnselectFilePolisEqId,
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
      List<AsetParCariModel> details,
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
                  2: const FixedColumnWidth(170), // Tertanggung
                  3: const FixedColumnWidth(240), // Alamat
                  4: const FixedColumnWidth(180), // Periode (gabungan)
                  5: const FixedColumnWidth(170), // Nilai Pertanggungan (curr + nilai)
                  6: const FixedColumnWidth(140), // Premi (curr + premi)
                },
                children: [
                  _tableHeader(context, details, compact: true),

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
                : const FlexColumnWidth(0.8), // radio button
            1: const FlexColumnWidth(1.0),   // No
            2: const FlexColumnWidth(2.2),   // Tertanggung
            3: const FlexColumnWidth(3.3),   // Alamat
            4: const FlexColumnWidth(2.0),   // Periode (gabungan)
            5: const FlexColumnWidth(2.0),   // Nilai Pertanggungan
            6: const FlexColumnWidth(1.6),   // Premi
          },
          children: [
            _tableHeader(context, details, compact: false),

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
      List<AsetParCariModel> details, {
        required bool compact,
      }) {
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
        }).toList(),
      ],
    );
  }

  TableRow _detailRowWithRadio(
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
            child: RadioButton(
              isSelected: isSelected,
              onTap: () {
                // Unselect semua item yang sedang terpilih (kecuali yang diklik)
                for (final item in widget.items) {
                  if (widget.selectedIds.contains(item.asetParId) && item.asetParId != d.asetParId) {
                    widget.onUnselect(item.asetParId);
                    if (item.filePolisParId.isNotEmpty) {
                      widget.onUnselectFilePolisParId(item.filePolisParId);
                    }
                    if (item.filePolisEqId.isNotEmpty) {
                      widget.onUnselectFilePolisEqId(item.filePolisEqId);
                    }
                  }
                }

                widget.onSelect(d.asetParId);

                widget.onSelectItem?.call(d); //ini coy

                if (d.filePolisParId.isNotEmpty) {
                  widget.onSelectFilePolisParId(d.filePolisParId);
                }
                if (d.filePolisEqId.isNotEmpty) {
                  widget.onSelectFilePolisEqId(d.filePolisEqId);
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
            "${d.periodeMulai} -\n${d.periodeAkhir}",
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