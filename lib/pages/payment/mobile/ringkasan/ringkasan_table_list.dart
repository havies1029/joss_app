import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';
import 'package:path/path.dart';

class RingkasanTablePage extends StatefulWidget {
  final List<DnrekapcobCariModel> items;
  final Set<String> selectedIds;
  final Function(String dn1Id) onSelect;
  final Function(String dn1Id) onUnselect;

  const RingkasanTablePage({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelect,
    required this.onUnselect,
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

      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
      ),

      itemBuilder: (context, index) {
        final item = widget.items[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: hPadding),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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

  // ============================
  // DETAIL TABLE
  // ============================
  Widget _buildBodyTableCompact(
      BuildContext context,
      DnrekapcobCariModel bodyItems,
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: const TableBorder(
              horizontalInside: BorderSide(color: sGrey),
              verticalInside: BorderSide(color: sGrey),
            ),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FixedColumnWidth(50),
              2: FixedColumnWidth(110), // dibuat lebih lega
              3: FixedColumnWidth(90),
              4: FixedColumnWidth(55),
              5: FixedColumnWidth(150),
              6: FixedColumnWidth(120),
            },
            children: [
              _tableHeader(context, [
                "",
                "NO",
                "KATEGORI",
                "JUMLAH\nPOLIS",
                "CURR",
                "TOTAL NILAI\nPERTANGGUNGAN",
                "TOTAL PREMI",
              ]),
              _detailRowWithCheckbox(
                context,
                bodyItems,
                index,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyTableNormal(
      BuildContext context,
      DnrekapcobCariModel bodyItems,
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
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2.3),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(2.5),
            6: FlexColumnWidth(2),
          },
          children: [
            _tableHeader(context, [
              "",
              "NO",
              "KATEGORI",
              "JUMLAH POLIS",
              "CURR",
              "TOTAL NILAI PERTANGGUNGAN",
              "TOTAL PREMI",
            ]),
            _detailRowWithCheckbox(
              context,
              bodyItems,
              index,
              compact: false,
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // TABLE HELPERS
  // ============================
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

  // ============================
  // TABLE HEADER
  // ============================
  // TableRow _tableHeader(BuildContext context) {
  //   return TableRow(
  //     decoration: BoxDecoration(color: formGrey),
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.all(6),
  //         child: SizedBox(), // checkbox header
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text(
  //           "NO",
  //           textAlign: TextAlign.center,
  //           style: bodyTextStyle(context, fontSize: 15),
  //         ),
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text("KATEGORI", style: bodyTextStyle(context, fontSize: 15)),
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text(
  //           "JUMLAH\nPOLIS",
  //           style: bodyTextStyle(context, fontSize: 15),
  //         ),
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text("CURR", style: bodyTextStyle(context, fontSize: 15)),
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text(
  //           "TOTAL NILAI\nPERTANGGUNGAN",
  //           style: bodyTextStyle(context, fontSize: 15),
  //         ),
  //       ),
  //
  //       Padding(
  //         padding: const EdgeInsets.all(6),
  //         child: Text(
  //           "TOTAL PREMI",
  //           style: bodyTextStyle(context, fontSize: 15),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ============================
  // DETAIL ROW WITH CHECKBOX
  // ============================
  TableRow _detailRowWithCheckbox(
      BuildContext context,
      DnrekapcobCariModel rows,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(rows.cobId);

    TextStyle cellStyle() => bodyTextStyle(context, fontSize: 15);

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        // Checkbox
        TableCell(
          child: Center(
            child: Checkbox(
              value: isSelected,
              onChanged: (checked) {
                if (checked == true) {
                  widget.onSelect(rows.cobId);
                } else {
                  widget.onUnselect(rows.cobId);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius / 2),
              ),
              side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: sGrey, width: 1),
              ),
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return Colors.transparent;
              }),
              checkColor: primaryLightColor,
            ),
          ),
        ),

        // NO
        TableCell(
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: cellStyle(),
            ),
          ),
        ),

        // Kategori
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              rows.cobNama,
              maxLines: compact ? 2 : null,
              overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
              style: cellStyle(),
            ),
          ),
        ),

        // Jumlah Polis
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.polisCount),
              style: cellStyle(),
            ),
          ),
        ),

        // Curr Symbol
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              rows.currSimbol,
              style: cellStyle(),
            ),
          ),
        ),

        // TSI
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.tsi),
              maxLines: compact ? 2 : null,
              overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
              style: cellStyle(),
            ),
          ),
        ),

        // Premi
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.polisAmount),
              style: cellStyle(),
            ),
          ),
        ),
      ],
    );
  }

  // ============================
  // FOOTER SUMMARY TABLE
  // ============================
  Widget _buildFooterTable(BuildContext context, DnrekapcobCariModel footers) {
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
            0: FlexColumnWidth(3), // Label
            1: FlexColumnWidth(1), // Curr
            2: FlexColumnWidth(3), // Value
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: pGrey),
              children: [
                // LABEL
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

                // CURRENCY
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    footers.currSimbol,
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),

                // VALUE
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatNum(footers.polisAmount),
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
