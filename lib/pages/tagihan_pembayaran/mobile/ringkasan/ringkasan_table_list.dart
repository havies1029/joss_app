// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/helper/hscroll_always_thumb_helper.dart';
// import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';
//
// class RingkasanTablePage extends StatefulWidget {
//   final List<DnrekapcobCariModel> items;
//   final Set<String> selectedIds;
//   final Function(String dn1Id) onSelect;
//   final Function(String dn1Id) onUnselect;
//
//   const RingkasanTablePage({
//     super.key,
//     required this.items,
//     required this.selectedIds,
//     required this.onSelect,
//     required this.onUnselect,
//   });
//
//   @override
//   State<RingkasanTablePage> createState() => _RingkasanTablePageState();
// }
//
// class _RingkasanTablePageState extends State<RingkasanTablePage> {
//   String formatNum(num value) {
//     return NumberFormat.decimalPattern().format(value);
//   }
//
//   void _toggleRow(DnrekapcobCariModel row) {
//     final isSelected = widget.selectedIds.contains(row.cobId);
//
//     if (isSelected) {
//       widget.onUnselect(row.cobId);
//     } else {
//       widget.onSelect(row.cobId);
//     }
//   }
//
//   Widget _tapCell({
//     required VoidCallback onTap,
//     required Widget child,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: child,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool isNarrow = width < 900;
//
//     return ListView.builder(
//       itemCount: widget.items.length,
//       padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//       itemBuilder: (context, index) {
//         final item = widget.items[index];
//
//         return Padding(
//           padding: const EdgeInsets.only(bottom: hPadding),
//           child: Card(
//             color: secondaryBlackColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(cardBorderRadius),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 isNarrow
//                     ? _buildBodyTableCompact(context, item, index)
//                     : _buildBodyTableNormal(context, item, index),
//                 const SizedBox(height: hPadding),
//                 _buildFooterTable(context, item),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBodyTableCompact(
//       BuildContext context,
//       DnrekapcobCariModel item,
//       int index,
//       ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//       child: Container(
//         decoration: BoxDecoration(
//           color: formGrey,
//           borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//           border: Border.all(color: sGrey),
//         ),
//         child: ScrollbarTheme(
//           data: ScrollbarThemeData(
//             thumbVisibility: WidgetStateProperty.all(false),
//             trackVisibility: WidgetStateProperty.all(false),
//             thickness: WidgetStateProperty.all(5),
//             radius: const Radius.circular(cardBorderRadius),
//             thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.1)),
//           ),
//           child: HScrollAlwaysThumb(
//             child: Table(
//               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//               border: const TableBorder(
//                 horizontalInside: BorderSide(color: sGrey),
//                 verticalInside: BorderSide(color: sGrey),
//               ),
//               columnWidths: const {
//                 0: FixedColumnWidth(50),
//                 1: FixedColumnWidth(110),
//                 2: FixedColumnWidth(90),
//                 3: FixedColumnWidth(55),
//                 4: FixedColumnWidth(150),
//                 5: FixedColumnWidth(120),
//               },
//               children: [
//                 _tableHeader(context, const [
//                   "NO",
//                   "KATEGORI",
//                   "JUMLAH\nPOLIS",
//                   "CURR",
//                   "TOTAL NILAI\nPERTANGGUNGAN",
//                   "TOTAL PREMI",
//                 ]),
//                 _detailRowClickable(
//                   context,
//                   item,
//                   index,
//                   compact: true,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBodyTableNormal(
//       BuildContext context,
//       DnrekapcobCariModel item,
//       int index,
//       ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//       child: Container(
//         decoration: BoxDecoration(
//           color: formGrey,
//           borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//           border: Border.all(color: sGrey),
//         ),
//         child: Table(
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           border: const TableBorder(
//             horizontalInside: BorderSide(color: sGrey),
//             verticalInside: BorderSide(color: sGrey),
//           ),
//           columnWidths: const {
//             0: FlexColumnWidth(1),
//             1: FlexColumnWidth(2.3),
//             2: FlexColumnWidth(1.5),
//             3: FlexColumnWidth(1),
//             4: FlexColumnWidth(2.5),
//             5: FlexColumnWidth(2),
//           },
//           children: [
//             _tableHeader(context, const [
//               "NO",
//               "KATEGORI",
//               "JUMLAH POLIS",
//               "CURR",
//               "TOTAL NILAI PERTANGGUNGAN",
//               "TOTAL PREMI",
//             ]),
//             _detailRowClickable(
//               context,
//               item,
//               index,
//               compact: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   TableRow _tableHeader(BuildContext context, List<String> cells) {
//     return TableRow(
//       decoration: const BoxDecoration(color: formGrey),
//       children: cells.map((text) {
//         final bool isNo = text.trim().toUpperCase() == "NO";
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
//           child: isNo
//               ? Center(
//             child: Text(
//               text,
//               style: bodyTextStyle(context, fontSize: 15),
//             ),
//           )
//               : Text(
//             text,
//             style: bodyTextStyle(context, fontSize: 15),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   TableRow _detailRowClickable(
//       BuildContext context,
//       DnrekapcobCariModel row,
//       int index, {
//         required bool compact,
//       }) {
//     final isSelected = widget.selectedIds.contains(row.cobId);
//     final onTap = () => _toggleRow(row);
//
//     TextStyle cellStyle() => bodyTextStyle(context, fontSize: 15);
//
//     BoxDecoration rowDecoration = BoxDecoration(
//       color: isSelected
//           ? primaryColor.withOpacity(0.25)
//           : (index.isEven ? pGrey : formGrey),
//     );
//
//     return TableRow(
//       decoration: rowDecoration,
//       children: [
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Center(
//               child: Text(
//                 (index + 1).toString(),
//                 style: cellStyle(),
//               ),
//             ),
//           ),
//         ),
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               row.cobNama,
//               maxLines: compact ? 2 : null,
//               overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
//               style: cellStyle(),
//             ),
//           ),
//         ),
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               formatNum(row.polisCount),
//               style: cellStyle(),
//             ),
//           ),
//         ),
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               row.currSimbol,
//               style: cellStyle(),
//             ),
//           ),
//         ),
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               formatNum(row.tsi),
//               maxLines: compact ? 2 : null,
//               overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
//               style: cellStyle(),
//             ),
//           ),
//         ),
//         _tapCell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               formatNum(row.polisAmount),
//               style: cellStyle(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFooterTable(BuildContext context, DnrekapcobCariModel item) {
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(cardBorderRadius),
//         bottomRight: Radius.circular(cardBorderRadius),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: pGrey,
//           borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//           border: Border.all(color: sGrey),
//         ),
//         child: Table(
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           border: const TableBorder(
//             horizontalInside: BorderSide(color: sGrey),
//             verticalInside: BorderSide(color: sGrey),
//           ),
//           columnWidths: const {
//             0: FlexColumnWidth(3),
//             1: FlexColumnWidth(1),
//             2: FlexColumnWidth(3),
//           },
//           children: [
//             TableRow(
//               decoration: BoxDecoration(color: pGrey),
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Grand Total:",
//                       style: bodyTextStyle(context, fontSize: 15),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text(
//                     item.currSimbol,
//                     style: bodyTextStyle(context, fontSize: 15),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       formatNum(item.polisAmount),
//                       style: bodyTextStyle(context, fontSize: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/hscroll_always_thumb_helper.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

class RingkasanTablePage extends StatefulWidget {
  final List<DnrekapcobCariModel> items;

  const RingkasanTablePage({
    super.key,
    required this.items,
  });

  @override
  State<RingkasanTablePage> createState() => _RingkasanTablePageState();
}

class _RingkasanTablePageState extends State<RingkasanTablePage> {
  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return ListView.builder(
      itemCount: widget.items.length,
      padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
      itemBuilder: (context, index) {
        final item = widget.items[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: hPadding),
          child: Card(
            color: secondaryBlackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isNarrow
                    ? _buildBodyTableCompact(context, item, index)
                    : _buildBodyTableNormal(context, item, index),
                const SizedBox(height: hPadding),
                _buildFooterTable(context, item),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyTableCompact(
      BuildContext context,
      DnrekapcobCariModel item,
      int index,
      ) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          border: Border.all(color: sGrey),
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(false),
            trackVisibility: WidgetStateProperty.all(false),
            thickness: WidgetStateProperty.all(5),
            radius: const Radius.circular(cardBorderRadius),
            thumbColor: WidgetStateProperty.all(scrollBar.withOpacity(0.1)),
          ),
          child: HScrollAlwaysThumb(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: const TableBorder(
                horizontalInside: BorderSide(color: sGrey),
                verticalInside: BorderSide(color: sGrey),
              ),
              columnWidths: const {
                0: FixedColumnWidth(50),
                1: FixedColumnWidth(110),
                2: FixedColumnWidth(90),
                3: FixedColumnWidth(55),
                4: FixedColumnWidth(150),
                5: FixedColumnWidth(120),
              },
              children: [
                _tableHeader(context, const [
                  "NO",
                  "KATEGORI",
                  "JUMLAH\nPOLIS",
                  "CURR",
                  "TOTAL NILAI\nPERTANGGUNGAN",
                  "TOTAL PREMI",
                ]),
                _detailRowReadOnly(
                  context,
                  item,
                  index,
                  compact: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyTableNormal(
      BuildContext context,
      DnrekapcobCariModel item,
      int index,
      ) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          border: Border.all(color: sGrey),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey),
            verticalInside: BorderSide(color: sGrey),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2.3),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(2.5),
            5: FlexColumnWidth(2),
          },
          children: [
            _tableHeader(context, const [
              "NO",
              "KATEGORI",
              "JUMLAH POLIS",
              "CURR",
              "TOTAL NILAI PERTANGGUNGAN",
              "TOTAL PREMI",
            ]),
            _detailRowReadOnly(
              context,
              item,
              index,
              compact: false,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: formGrey),
      children: cells.map((text) {
        final bool isNo = text.trim().toUpperCase() == "NO";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
          child: isNo
              ? Center(
            child: Text(
              text,
              style: bodyTextStyle(context, fontSize: 15),
            ),
          )
              : Text(
            text,
            style: bodyTextStyle(context, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }

  TableRow _detailRowReadOnly(
      BuildContext context,
      DnrekapcobCariModel row,
      int index, {
        required bool compact,
      }) {
    TextStyle cellStyle() => bodyTextStyle(context, fontSize: 15);

    final BoxDecoration rowDecoration = BoxDecoration(
      color: index.isEven ? pGrey : formGrey,
    );

    return TableRow(
      decoration: rowDecoration,
      children: [
        _cell(
          context,
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: cellStyle(),
            ),
          ),
          padding: const EdgeInsets.all(10),
        ),
        _cell(
          context,
          child: Text(
            row.cobNama,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: cellStyle(),
          ),
        ),
        _cell(
          context,
          child: Text(
            formatNum(row.polisCount),
            style: cellStyle(),
          ),
        ),
        _cell(
          context,
          child: Text(
            row.currSimbol,
            style: cellStyle(),
          ),
        ),
        _cell(
          context,
          child: Text(
            formatNum(row.tsi),
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: cellStyle(),
          ),
        ),
        _cell(
          context,
          child: Text(
            formatNum(row.polisAmount),
            style: cellStyle(),
          ),
        ),
      ],
    );
  }

  Widget _cell(
      BuildContext context, {
        required Widget child,
        EdgeInsets padding = const EdgeInsets.all(6),
      }) {
    return Padding(
      padding: padding,
      child: child,
    );
  }

  Widget _buildFooterTable(BuildContext context, DnrekapcobCariModel item) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(cardBorderRadius),
        bottomRight: Radius.circular(cardBorderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          border: Border.all(color: sGrey),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey),
            verticalInside: BorderSide(color: sGrey),
          ),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(3),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: pGrey),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Grand Total:",
                      style: bodyTextStyle(context, fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    item.currSimbol,
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatNum(item.polisAmount),
                      style: bodyTextStyle(context, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}