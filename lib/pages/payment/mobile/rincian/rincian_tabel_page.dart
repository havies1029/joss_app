import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/payment/dndetailsppa_model.dart';
import 'package:joss_app/models/payment/dnfootercob_model.dart';
import 'package:joss_app/models/payment/dnheadercob_model.dart';

import '../../../../common/constants.dart';
import '../../../../widgets/apptheme/dialog_detail_polis.dart';

class RincianTablePage extends StatefulWidget {
  final List<DnHeaderCobModel> headers;
  final List<String> selectedIds;
  final Function(String dn1Id) onSelect;
  final Function(String dn1Id) onUnselect;
  final bool readOnly;
  final bool showFooter;

  const RincianTablePage({
    super.key,
    required this.headers,
    required this.selectedIds,
    required this.onSelect,
    required this.onUnselect,
    this.readOnly = false,
    this.showFooter = true,
  });

  @override
  State<RincianTablePage> createState() => _RincianTablePageState();
}

class _RincianTablePageState extends State<RincianTablePage> {
  final ScrollController hController = ScrollController();

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  List<DnDetailSppaModel> _filteredDetails(
      List<DnDetailSppaModel> details,
      ) {
    if (!widget.readOnly) return details;

    return details
        .where((d) => widget.selectedIds.contains(d.dn1Id))
        .toList();
  }

  @override
  void dispose() {
    hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return ListView.builder(
      itemCount: widget.headers.length,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
      ),
      itemBuilder: (context, index) {
        final header = widget.headers[index];
        final filteredDetails = _filteredDetails(header.details);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTitle(context, header),
            const SizedBox(height: hPadding),

        isNarrow
        ? _buildDetailTableCompact(filteredDetails)
            : _buildDetailTableNormal(filteredDetails),

            if (widget.showFooter)
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

    return StatefulBuilder(
      builder: (context, setState) {
        return ClipRRect(
          borderRadius: widget.readOnly
              ? BorderRadius.circular(cardBorderRadius)
              : BorderRadius.only(
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
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all(true),
                trackVisibility: MaterialStateProperty.all(false),
                thickness: MaterialStateProperty.all(5),
                radius: Radius.circular(cardBorderRadius),
                thumbColor: MaterialStateProperty.all(
                  scrollBar.withOpacity(0.25),
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
                          : const FixedColumnWidth(40),
                      1: const FixedColumnWidth(50),
                      2: const IntrinsicColumnWidth(),
                      3: const IntrinsicColumnWidth(),
                      4: const FixedColumnWidth(80),
                      5: const FixedColumnWidth(120),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailTableNormal(List<DnDetailSppaModel> details) {
    if (details.isEmpty) return const Text("Tidak ada detail polis");

    return ClipRRect(
      borderRadius: widget.readOnly
          ? BorderRadius.circular(cardBorderRadius)
          : BorderRadius.only(
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
          columnWidths: {
            0: widget.readOnly
                ? const FixedColumnWidth(0)
                : const FlexColumnWidth(1),
            1: const FlexColumnWidth(1),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(3),
            4: const FlexColumnWidth(1.5),
            5: const FlexColumnWidth(2),
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


  void _showDetailPopup(BuildContext context, DnDetailSppaModel d) {
    DialogDetailPolis.show(
      context,
      title: "Detail",
      items: [
        DetailItem(
          label: "NO",
          value: d.rownumber.toString(),
        ),
        DetailItem(
          label: "NO POLIS",
          value: d.noPolis,
        ),
        DetailItem(
          label: "Tanggal Mulai",
          value: d.polisMulai.toString().substring(0, 10),
        ),
        DetailItem(
          label: "Tanggal Berakhir",
          value: d.polisAkhir.toString().substring(0, 10),
        ),
        DetailItem(
          label: "Total Premi",
          value: "${d.currSimbol} ${formatNum(d.dnOs)}",
        ),
      ],
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
                  widget.onSelect(d.dn1Id);
                } else {
                  widget.onUnselect(d.dn1Id);
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
                states.contains(MaterialState.selected)
                    ? primaryColor
                    : Colors.transparent,
              ),
              checkColor: primaryLightColor,
            ),
          )
        else
          const SizedBox(),

        _tapCell(
          context: context,
          data: d,
          child: Center(
            child: Text(
              d.rownumber.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),

        _tapCell(
          context: context,
          data: d,
          child: Text(
            d.noPolis,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _tapCell(
          context: context,
          data: d,
          child: Text(
            "${d.polisMulai.toString().substring(0, 10)} → "
                "${d.polisAkhir.toString().substring(0, 10)}",
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _tapCell(
          context: context,
          data: d,
          child: Text(
            d.currSimbol,
            style: TextStyle(color: primaryLightColor),
          ),
        ),

        _tapCell(
          context: context,
          data: d,
          child: Text(
            formatNum(d.dnOs),
            style: TextStyle(color: primaryLightColor),
          ),
        ),
      ],
    );
  }

  Widget _tapCell({
    required BuildContext context,
    required DnDetailSppaModel data,
    required Widget child,
  }) {
    return InkWell(
      onTap: () => _showDetailPopup(context, data),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: child,
      ),
    );
  }
}