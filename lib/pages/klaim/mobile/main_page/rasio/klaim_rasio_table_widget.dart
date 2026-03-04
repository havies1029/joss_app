import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrasio/klaimrasiocobcari_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiocobcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiodetailcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiograndcurrcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiosumcurrcari_model.dart';

class KlaimRasioTableWidget extends StatefulWidget {
  const KlaimRasioTableWidget({super.key});

  @override
  KlaimRasioTableWidgetState createState() => KlaimRasioTableWidgetState();
}

class KlaimRasioTableWidgetState extends State<KlaimRasioTableWidget> {
  late KlaimrasiocobCariBloc klaimrasiocobCariBloc;
  //final ScrollController hController = ScrollController();

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  void dispose() {
    //hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimrasiocobCariBloc = BlocProvider.of<KlaimrasiocobCariBloc>(context);
    final width = MediaQuery.of(context).size.width;
    final bool isNarrow = width < 900;

    return BlocConsumer<KlaimrasiocobCariBloc, KlaimrasiocobCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          return state.klaimRasio.cobs.isNotEmpty
              ? ListView.builder(
            itemCount: state.klaimRasio.cobs.length,
            padding: EdgeInsets.symmetric(
              horizontal: hPadding * 1.5,
            ),
            itemBuilder: (context, index) {
              final header = state.klaimRasio.cobs[index];
              return Container(
                color: secondaryBlackColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTitle(context, header),
                    const SizedBox(height: hPadding),
                    isNarrow
                        ? ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbVisibility:
                        WidgetStateProperty.all(false),
                        trackVisibility:
                        WidgetStateProperty.all(false),
                        thickness: WidgetStateProperty.all(5),
                        radius: Radius.circular(cardBorderRadius),
                        thumbColor: WidgetStateProperty.all(
                          scrollBar.withOpacity(0.25),
                        ),
                      ),
                      child: Scrollbar(
                        //controller: hController,
                        //thumbVisibility: true,
                        child: SingleChildScrollView(
                          //controller: hController,
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              _buildDetailTableCompact(
                                  header.details),
                              _buildFooterTable(
                                  header.footers, isNarrow),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Column(
                      children: [
                        _buildDetailTableNormal(header.details),
                        _buildFooterTable(header.footers, isNarrow),
                      ],
                    ),
                    const SizedBox(height: hPadding),
                    if (index == state.klaimRasio.cobs.length - 1 &&
                        state.klaimRasio.grandcurrs.isNotEmpty)
                      _buildGrandTotalCard(state.klaimRasio.grandcurrs),
                  ],
                ),
              );
            },
          )
              : const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available x!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Data Available y!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) {
        return (current.status == ListStatus.success);
      },
      listener: (context, state) {},
    );
  }

  Widget _buildHeaderTitle(
      BuildContext context, KlaimrasiocobCariModel header) {
    return Text(header.cobNama, style: headingStyle(context, fontSize: 14));
  }

  Widget _buildDetailTableCompact(List<KlaimrasiodetailCariModel> details) {
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
            0: FixedColumnWidth(40),
            1: FixedColumnWidth(100),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(50),
            4: FixedColumnWidth(120),
            5: FixedColumnWidth(100),
            6: FixedColumnWidth(50),
          },
          children: [
            _tableHeader(context, [
              "NO",
              "NO POLIS",
              "PERIODE POLIS",
              "CURR",
              "PREMI",
              "KLAIM",
              "RASIO",
            ]),
            ...details.asMap().entries.map(
                  (e) => _detailRow(
                e.value,
                e.key,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTableNormal(List<KlaimrasiodetailCariModel> details) {
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
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(4),
            5: FlexColumnWidth(3),
            6: FlexColumnWidth(1),
          },
          children: [
            _tableHeader(context, [
              "NO",
              "NO POLIS",
              "PERIODE POLIS",
              "CURR",
              "PREMI",
              "KLAIM",
              "RASIO",
            ]),
            ...details.asMap().entries.map(
                  (e) => _detailRow(
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

  Widget _buildFooterTable(
      List<KlaimrasiosumcurrCariModel> footers, bool isNarrow) {
    if (footers.isEmpty) return const SizedBox.shrink();

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
        child: _buildFooterTableContent(footers, isNarrow),
      ),
    );
  }

  Widget _buildFooterTableContent(
      List<KlaimrasiosumcurrCariModel> footers, bool compact) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: const TableBorder(
        horizontalInside: BorderSide(color: sGrey, width: 1),
        verticalInside: BorderSide(color: sGrey, width: 1),
      ),
      columnWidths: compact
          ? const {
        0: FixedColumnWidth(240),
        1: FixedColumnWidth(50),
        2: FixedColumnWidth(120),
        3: FixedColumnWidth(100),
        4: FixedColumnWidth(50),
      }
          : const {
        0: FlexColumnWidth(6),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(4),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(1),
      },
      children: [
        ...footers.map(
              (f) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sub Total: ",
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    f.curr,
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatNum(f.premiAmount),
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatNum(f.klaimAmount),
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${formatNum(f.rasio)}%",
                    style: bodyTextStyle(context, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
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

  TableRow _detailRow(
      KlaimrasiodetailCariModel d,
      int index, {
        required bool compact,
      }) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              d.nourut.toString(),
              style: TextStyle(color: primaryLightColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            d.polisNo,
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            "${d.periodeMulai.toString().substring(0, 10)} - "
                "${d.periodeAkhir.toString().substring(0, 10)}",
            maxLines: compact ? 2 : null,
            overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            d.curr,
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            formatNum(d.premiAmount),
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            formatNum(d.klaimAmount),
            style: TextStyle(color: primaryLightColor),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(6),
            child: Center(
              child: Text(
                "${formatNum(d.rasio)}%",
                style: TextStyle(color: primaryLightColor),
              ),
            )),
      ],
    );
  }

  Widget _buildGrandTotalCard(List<KlaimrasiograndcurrCariModel> totals) {
    return Padding(
      padding: const EdgeInsets.only(top: hPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(color: sGrey, width: 1),
          ),
          child: Column(
            children: [
              // GRAND TOTAL HEADER (FULL WIDTH)
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: pGrey,
                    border: Border(
                      bottom: BorderSide(color: sGrey, width: 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Grand Total:",
                      style: headingStyle(context, fontSize: 14),
                    ),
                  )),
              // TABLE WITH COLUMN HEADERS AND DATA
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: sGrey, width: 1),
                  verticalInside: BorderSide(color: sGrey, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                },
                children: [
                  // COLUMN HEADER ROW
                  TableRow(
                    decoration: const BoxDecoration(color: formGrey),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "CURR",
                              style: bodyTextStyle(context, fontSize: 15),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Premi",
                            style: bodyTextStyle(context, fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Klaim",
                            style: bodyTextStyle(context, fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Rasio",
                            style: bodyTextStyle(context, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DATA ROWS
                  ...totals.asMap().entries.map(
                        (entry) {
                      final index = entry.key;
                      final g = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: index.isEven ? pGrey : formGrey,
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  g.curr,
                                  style: bodyTextStyle(context, fontSize: 15),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                formatNum(g.premiAmount),
                                style: bodyTextStyle(context, fontSize: 15),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                formatNum(g.klaimAmount),
                                style: bodyTextStyle(context, fontSize: 15),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${formatNum(g.rasio)}%",
                                style: bodyTextStyle(context, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}