import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

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

  final ScrollController hController = ScrollController();

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }


  double _measureTextWidth(
      BuildContext context,
      String text, {
        TextStyle? style,
      }) {
    final effectiveStyle = style ?? bodyTextStyle(context, fontSize: 15);

    final tp = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: Directionality.of(context),
      maxLines: 1,
      ellipsis: '…',
    )..layout();

    return tp.width;
  }

  double _clampedWidthFromText(
      BuildContext context, {
        required String header,
        required String value,
        required double min,
        required double max,
        double padding = 20,
      }) {
    final style = bodyTextStyle(context, fontSize: 15);
    final wHeader = _measureTextWidth(context, header, style: style);
    final wValue = _measureTextWidth(context, value, style: style);
    final target = (wHeader > wValue ? wHeader : wValue) + padding;
    return target.clamp(min, max);
  }

  Map<int, TableColumnWidth> _compactColumnWidthsFor(
      BuildContext context,
      DnrekapcobCariModel row,
      ) {
    // kolom 0 = checkbox, ini jangan ikut data biar konsisten
    const wCheckbox = 50.0;

    // kolom 1 = NO, tetap fixed kecil
    const wNo = 50.0;

    // value string yang dipakai untuk ukur
    final kategoriVal = row.cobNama;
    final jmlPolisVal = formatNum(row.polisCount);
    final currVal = row.currSimbol;
    final tsiVal = formatNum(row.tsi);
    final premiVal = formatNum(row.polisAmount);

    final wKategori = _clampedWidthFromText(
      context,
      header: "KATEGORI",
      value: kategoriVal,
      min: 120,
      max: 220, // mentok -> wrap maxLines
    );

    final wJmlPolis = _clampedWidthFromText(
      context,
      header: "JUMLAH POLIS",
      value: jmlPolisVal,
      min: 90,
      max: 130,
    );

    final wCurr = _clampedWidthFromText(
      context,
      header: "CURR",
      value: currVal,
      min: 55,
      max: 85,
      padding: 14,
    );

    final wTsi = _clampedWidthFromText(
      context,
      header: "TOTAL NILAI PERTANGGUNGAN",
      value: tsiVal,
      min: 140,
      max: 210,
    );

    final wPremi = _clampedWidthFromText(
      context,
      header: "TOTAL PREMI",
      value: premiVal,
      min: 110,
      max: 170,
    );

    return {
      0: const FixedColumnWidth(wCheckbox),
      1: const FixedColumnWidth(wNo),
      2: FixedColumnWidth(wKategori),
      3: FixedColumnWidth(wJmlPolis),
      4: FixedColumnWidth(wCurr),
      5: FixedColumnWidth(wTsi),
      6: FixedColumnWidth(wPremi),
    };
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
            color: secondaryBlackColor,
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
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all(true),
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
                  horizontalInside: BorderSide(color: sGrey),
                  verticalInside: BorderSide(color: sGrey),
                ),
                columnWidths: const {
                  // 0: FixedColumnWidth(50),
                  0: FixedColumnWidth(50),
                  1: FixedColumnWidth(110), // dibuat lebih lega
                  2: FixedColumnWidth(90),
                  3: FixedColumnWidth(55),
                  4: FixedColumnWidth(150),
                  5: FixedColumnWidth(120),
                },
                children: [
                  _tableHeader(context, [
                    // "",
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
            // 0: FlexColumnWidth(1),
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2.3),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(2.5),
            5: FlexColumnWidth(2),
          },
          children: [
            _tableHeader(context, [
              // "",
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
        // // Checkbox
        // TableCell(
        //   child: Center(
        //     child: Checkbox(
        //       value: isSelected,
        //       onChanged: (checked) {
        //         if (checked == true) {
        //           widget.onSelect(rows.cobId);
        //         } else {
        //           widget.onUnselect(rows.cobId);
        //         }
        //       },
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(cardBorderRadius / 2),
        //       ),
        //       side: MaterialStateBorderSide.resolveWith(
        //             (states) => const BorderSide(color: sGrey, width: 1),
        //       ),
        //       fillColor: MaterialStateProperty.resolveWith((states) {
        //         if (states.contains(MaterialState.selected)) {
        //           return primaryColor;
        //         }
        //         return Colors.transparent;
        //       }),
        //       checkColor: primaryLightColor,
        //     ),
        //   ),
        // ),

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
