import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../common/constants.dart';
import 'package:joss_app/models/payment/dngrandtotal_model.dart';

class RincianGrandTotalTableWidget extends StatelessWidget {
  final List<DnGrandTotalModel> grandTotals;

  const RincianGrandTotalTableWidget({
    super.key,
    required this.grandTotals,
  });

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (grandTotals.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
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
        children: grandTotals.map(
              (g) => TableRow(
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

              // VALUE
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
                        g.currSimbol,
                        style: bodyTextStyle(context, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatNum(g.totalOs),
                      style: headingStyle(context, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).toList(),
      ),
    );
  }
}