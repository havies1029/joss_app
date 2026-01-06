import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/payment/dndetailsppa_model.dart';
import 'package:joss_app/models/payment/dnfootercob_model.dart';
import 'package:joss_app/models/payment/dnheadercob_model.dart';

import '../../../../common/constants.dart';

class RincianTablePage extends StatefulWidget {
  final List<DnHeaderCobModel> headers;
  final List<String> selectedIds;
  final Function(String dn1Id) onSelect;
  final Function(String dn1Id) onUnselect;

  const RincianTablePage({
    super.key,
    required this.headers,
    required this.selectedIds,
    required this.onSelect,
    required this.onUnselect,
  });

  @override
  State<RincianTablePage> createState() => _RincianTablePageState();
}

class _RincianTablePageState extends State<RincianTablePage> {
  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return ListView.builder(
      itemCount: widget.headers.length,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: 8,
      ),
      itemBuilder: (context, index) {
        final header = widget.headers[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTitle(context, header),
            const SizedBox(height: hPadding),

            isNarrow
                ? _buildDetailTableCompact(header.details)
                : _buildDetailTableNormal(header.details),

            _buildFooterTable(header.footers),
          ],
        );
      },
    );
  }

  Widget _buildHeaderTitle(BuildContext context, DnHeaderCobModel header) {
    return Text(
      "Polis ${header.cobNama}",
      style: headingStyle(context, fontSize: 14),
    );
  }

  Widget _buildDetailTableCompact(List<DnDetailSppaModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(cardBorderRadius),
        topRight: Radius.circular(cardBorderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cardBorderRadius),
            topRight: Radius.circular(cardBorderRadius),
          ),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 0.5),
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
            columnWidths: const {
              0: FixedColumnWidth(40),
              1: FixedColumnWidth(50),
              2: IntrinsicColumnWidth(),
              3: IntrinsicColumnWidth(),
              4: FixedColumnWidth(80),
              5: FixedColumnWidth(120),
            },
            children: [
              _tableHeader(context, [
                "",
                "NO",
                "NO POLIS",
                "PERIODE POLIS",
                "CURR",
                "PREMI",
              ]),
              ...details.asMap().entries.map(
                    (e) => _detailRowWithCheckbox(
                  e.value,
                  e.key,
                  compact: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTableNormal(List<DnDetailSppaModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(cardBorderRadius),
        topRight: Radius.circular(cardBorderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cardBorderRadius),
            topRight: Radius.circular(cardBorderRadius),
          ),
          border: const Border(
            top: BorderSide(color: sGrey, width: 1),
            left: BorderSide(color: sGrey, width: 1),
            right: BorderSide(color: sGrey, width: 1),
            bottom: BorderSide(color: sGrey, width: 0.5),
          ),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
            verticalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(3),
            4: FlexColumnWidth(1.5),
            5: FlexColumnWidth(2),
          },
          children: [
            _tableHeader(context, [
              "",
              "NO",
              "NO POLIS",
              "PERIODE POLIS",
              "CURR",
              "PREMI",
            ]),
            ...details.asMap().entries.map(
                  (e) => _detailRowWithCheckbox(
                e.value,
                e.key,
                compact: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterTable(List<DnFooterCobModel> footers) {
    if (footers.isEmpty) return const Text("Tidak ada footer summary");

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(cardBorderRadius),
        bottomRight: Radius.circular(cardBorderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(cardBorderRadius),
            bottomRight: Radius.circular(cardBorderRadius),
          ),
          border: const Border(
            top: BorderSide(color: sGrey, width: 0.5),
            left: BorderSide(color: sGrey, width: 0.5),
            right: BorderSide(color: sGrey, width: 0.5),
            bottom: BorderSide(color: sGrey, width: 1),
          ),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(
            horizontalInside: BorderSide(color: sGrey, width: 1),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            ...footers.map(
                  (f) => TableRow(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sub Total:",
                        style: bodyTextStyle(context, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: formGrey,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: sGrey),
                          ),
                          child: Text(
                            f.currSimbol,
                            style: bodyTextStyle(context, fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatNum(f.totalOs),
                          style: bodyTextStyle(context, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TableRow _tableHeader(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: cells
          .map(
            (text) => Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: bodyTextStyle(context, fontSize: 15),
          ),
        ),
      )
          .toList(),
    );
  }

  TableRow _detailRowWithCheckbox(
      DnDetailSppaModel d,
      int index, {
        required bool compact,
      }) {
    final isSelected = widget.selectedIds.contains(d.dn1Id);

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withOpacity(0.3)
            : (index.isEven ? pGrey : formGrey),
      ),
      children: [
        Center(
          child: Checkbox(
            value: isSelected,
            onChanged: (checked) {
              if (checked == true) {
                widget.onSelect(d.dn1Id);
              } else {
                widget.onUnselect(d.dn1Id);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(color: sGrey),
            ),
            fillColor: MaterialStateProperty.resolveWith(
                  (states) =>
              states.contains(MaterialState.selected)
                  ? primaryColor
                  : Colors.transparent,
            ),
            checkColor: primaryLightColor,
          ),
        ),

        Center(
          child: Text(
            d.rownumber.toString(),
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        Center(
          child: Text(
            d.noPolis,
            maxLines: compact ? 2 : null,
            overflow:
            compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            "${d.polisMulai.toString().substring(0, 10)} → "
                "${d.polisAkhir.toString().substring(0, 10)}",
            maxLines: compact ? 2 : null,
            overflow:
            compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.currSimbol,
              style: TextStyle(color: primaryLightColor)),
        ),

        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            formatNum(d.dnOs),
            style: TextStyle(color: primaryLightColor),
          ),
        ),
      ],
    );
  }
}