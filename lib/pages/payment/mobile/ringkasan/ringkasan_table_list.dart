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
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBodyTable(context, item, index),
              const SizedBox(height: hPadding),
              _buildFooterTable(context, item),
            ],
          ),
        );
      },
    );
  }

  // ============================
  // DETAIL TABLE
  // ============================
  Widget _buildBodyTable(
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
              0: FixedColumnWidth(50), // Checkbox  (35 + 15)
              1: FixedColumnWidth(50), // No        (35 + 15)
              2: FixedColumnWidth(70), // Kategori  (55 + 15)
              3: FixedColumnWidth(70), // Jumlah Polis (55 + 15)
              4: FixedColumnWidth(55), // Curr      (40 + 15)
              5: FixedColumnWidth(115), // TSI       (100 + 15)
              6: FixedColumnWidth(95), // Premi     (80 + 15)
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
              _detailRowWithCheckbox(context, bodyItems, index),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // TABLE HELPERS
  // ============================
  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: formGrey),
      children:
          cells.map((text) {
            final isNo = text == "No";

            return Padding(
              padding: const EdgeInsets.all(6),
              child:
                  isNo
                      ? Center(
                        child: Text(
                          text,
                          style: bodyTextStyle(context, fontSize: 15),
                        ),
                      )
                      : Text(text, style: bodyTextStyle(context, fontSize: 15)),
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
    int index,
  ) {
    final isSelected = widget.selectedIds.contains(rows.cobId);

    return TableRow(
      decoration: BoxDecoration(
        color:
            isSelected
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
                (states) => BorderSide(color: sGrey, width: 1),
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
              style: bodyTextStyle(context, fontSize: 15),
            ),
          ),
        ),

        // Kategori
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              rows.cobNama,
              style: bodyTextStyle(context, fontSize: 15),
            ),
          ),
        ),

        // Jumlah Polis
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.polisCount),
              style: bodyTextStyle(context, fontSize: 15),
            ),
          ),
        ),

        // Curr Symbol
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              rows.currSimbol,
              style: bodyTextStyle(context, fontSize: 15),
            ),
          ),
        ),

        // Total Nilai Pertanggungan (TSI)
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.tsi),
              style: bodyTextStyle(context, fontSize: 15),
            ),
          ),
        ),

        // Total Premi (Polis Amount)
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              formatNum(rows.polisAmount),
              style: bodyTextStyle(context, fontSize: 15),
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
