// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../common/constants.dart';
// import '../../../../models/gen_aset_health/asethealthcari_model.dart';
//
// class HealthCobTable extends StatefulWidget {
//   final List<AsetHealthCariModel> items;
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
//   const HealthCobTable({
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
//   State<HealthCobTable> createState() => _HealthCobTableState();
// }
//
// class _HealthCobTableState extends State<HealthCobTable> {
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
//   bool _isAllSelected(List<AsetHealthCariModel> details) {
//     if (details.isEmpty) return false;
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => selected.contains(d.asethealthId));
//   }
//
//   bool _isNoneSelected(List<AsetHealthCariModel> details) {
//     final selected = widget.selectedIds.toSet();
//     return details.every((d) => !selected.contains(d.asethealthId));
//   }
//
//   void _toggleSelectAll(bool checked, List<AsetHealthCariModel> details) {
//     for (final d in details) {
//       final id = d.asethealthId;
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
//   List<AsetHealthCariModel> get _filteredItems {
//     if (!widget.readOnly) return widget.items;
//     return widget.items.where((d) => widget.selectedIds.contains(d.asethealthId)).toList();
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
//       List<AsetHealthCariModel> details,
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
//                   2: const FixedColumnWidth(250), // Nama
//                   3: const FixedColumnWidth(290), // Benefit
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
//   Widget _buildDetailTableNormal(BuildContext context, List<AsetHealthCariModel> details) {
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
//             2: const FlexColumnWidth(3.9),   // Nama
//             3: const FlexColumnWidth(3.7),   // Benefit
//             4: const FlexColumnWidth(1.4), // Status
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
//       List<AsetHealthCariModel> details,
//       ) {
//     if (widget.readOnly) {
//       return _tableHeader(context, [
//         "",
//         "No",
//         "Nama",
//         "Benefit",
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
//               // sama persis kayak MV: minus/false => select all, true => unselect all
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
//           "Nama",
//           "Benefit",
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
//       AsetHealthCariModel d,
//       int index, {
//         required bool compact,
//       }) {
//     final isSelected = widget.selectedIds.contains(d.asethealthId);
//
//     return TableRow(
//       decoration: BoxDecoration(
//         color: (!widget.readOnly && isSelected)
//             ? primaryColor.withOpacity(0.3)
//             : (index.isEven ? pGrey : formGrey),
//       ),
//       children: [
//         // checkbox (style tetap sama)
//         if (!widget.readOnly)
//           Center(
//             child: Checkbox(
//               value: isSelected,
//               onChanged: (checked) {
//                 if (checked == true) {
//                   widget.onSelect(d.asethealthId);
//                   if (d.filePolisId.isNotEmpty) {
//                     widget.onSelectFilePolisHealthId(d.filePolisId);
//                   }
//                 } else {
//                   widget.onUnselect(d.asethealthId);
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
//         // No
//         _cell(
//           child: Center(
//             child: Text(
//               d.nomor.toString(),
//               style: TextStyle(color: primaryLightColor),
//             ),
//           ),
//         ),
//
//         // Nama (pakai field "nama" sesuai debugPrint kamu)
//         _cell(
//           child: Text(
//             d.nama,
//             maxLines: compact ? 2 : 1,
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
import '../../../../models/gen_aset_health/asethealthcari_model.dart';

class HealthCobTable extends StatefulWidget {
  final List<AsetHealthCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetHealthCariModel item)? onSelectItem;
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
    required this.onSelectItem,
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

  List<AsetHealthCariModel> get _filteredItems {
    if (!widget.readOnly) return widget.items;
    return widget.items.where((d) => widget.selectedIds.contains(d.asethealthId)).toList();
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
      List<AsetHealthCariModel> details,
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
                  2: const FixedColumnWidth(250), // Nama
                  3: const FixedColumnWidth(290), // Benefit
                },
                children: [
                  _tableHeader(context, details),
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
            0: widget.readOnly ? const FixedColumnWidth(0) : const FlexColumnWidth(0.8), // radio button
            1: const FlexColumnWidth(1.0),   // No
            2: const FlexColumnWidth(3.9),   // Nama
            3: const FlexColumnWidth(3.7),   // Benefit
          },
          children: [
            _tableHeader(context, details),
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

  TableRow _tableHeader(
      BuildContext context,
      List<AsetHealthCariModel> details,
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
          "Nama",
          "Benefit",
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

  TableRow _detailRowWithCheckbox(
      BuildContext context,
      AsetHealthCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedProsesId == d.prosesId;

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
                  widget.selectedProsesId(d.prosesId);
                  widget.onSelect(d.asethealthId);
                  widget.onSelectItem?.call(d);

                  if (d.filePolisId.isNotEmpty) {
                    widget.onSelectFilePolisHealthId(d.filePolisId);
                  }
                } else {
                  widget.onUnselect(d.asethealthId);
                  widget.selectedProsesId("");
                  if (d.filePolisId.isNotEmpty) {
                    widget.onUnselectFilePolisHealthId(d.filePolisId);
                  }
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

        // No
        _cell(
          child: Center(
            child: Text(
              d.nomor.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Nama
        _cell(
          child: Text(
            d.nama,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Benefit: hanya ada di compact mode (karena compact table punya kolom Benefit)
        if (compact)
          _cell(
            child: Text(
              d.status ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryLightColor),
            ),
          ),
      ],
    );
  }

  TableRow _detailRowWithRadio(
      BuildContext context,
      AsetHealthCariModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(d.asethealthId);

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
                  if (widget.selectedIds.contains(item.asethealthId) && item.asethealthId != d.asethealthId) {
                    widget.onUnselect(item.asethealthId);
                    if (item.filePolisId.isNotEmpty) {
                      widget.onUnselectFilePolisHealthId(item.filePolisId);
                    }
                  }
                }

                widget.onSelect(d.asethealthId);

                widget.onSelectItem?.call(d); //ini coy

                if (d.filePolisId.isNotEmpty) {
                  widget.onSelectFilePolisHealthId(d.filePolisId);
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
              d.nomor.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        // Nama (pakai field "nama" sesuai debugPrint kamu)
        _cell(
          child: Text(
            d.nama,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        // Benefit - hanya tampil di compact mode karena columnWidths normal tidak punya kolom ke-3
        if (compact)
          _cell(
            child: Text(
              d.status ?? '-',
              maxLines: 2,
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