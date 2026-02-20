import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';
import 'package:joss_app/pages/payment/dnsppamvcari_list.dart';

class RingkasanDetailTableList extends StatelessWidget {
  final List<DnsppaCariModel> items;

  const RingkasanDetailTableList({
    super.key,
    required this.items,
  });

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: formGrey,
          border: Border.all(color: sGrey),
          borderRadius: BorderRadius.circular(cardBorderRadius),
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
              0: FixedColumnWidth(50),   // NO
              1: FixedColumnWidth(150),  // NO POLIS (klik)
              2: FixedColumnWidth(180),  // PERIODE
              3: FixedColumnWidth(60),   // CURR
              4: FixedColumnWidth(120),  // PREMI
            },
            children: [
              _tableHeader(context),
              ...items.asMap().entries.map(
                    (e) => _detailRow(context, e.key, e.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // HEADER
  // =========================
  TableRow _tableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: [
        _headerCell(context, "NO"),
        _headerCell(context, "NO POLIS"),
        _headerCell(context, "PERIODE POLIS"),
        _headerCell(context, "CURR"),
        _headerCell(context, "PREMI"),
      ],
    );
  }

  Widget _headerCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical:15),
      child: Text(
        text,
        style: bodyTextStyle(context, fontSize: 15),
      ),
    );
  }

  // =========================
  // ROW
  // =========================
  TableRow _detailRow(
      BuildContext context,
      int index,
      DnsppaCariModel row,
      ) {
    final DateFormat dateFmt = DateFormat("dd/MM/yyyy");

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : formGrey,
      ),
      children: [
        _cell(context, (index + 1).toString()),
        _polisCell(context, row),
        _cell(
          context,
          "${dateFmt.format(row.polisMulai)} - ${dateFmt.format(row.polisAkhir)}",
        ),
        _cell(context, row.currSimbol),
        _cell(context, formatNum(row.dnOs)),
        // _cell(context, row.dn1Id),
        // _cell(context, row.objectDesc),
        //
        // _cell(context, DateFormat("dd/MM/yyyy").format(row.polisMulai)),
        // _cell(context, DateFormat("dd/MM/yyyy").format(row.polisAkhir)),
        // _actionCell(context, row.sppa1Id),
      ],
    );
  }
  Widget _polisCell(BuildContext context, DnsppaCariModel row) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DnsppamvCariPage(sppa1Id: row.sppa1Id),
            ),
          );
        },
        child: Text(
          row.noPolis,
          style: bodyTextStyle(context, fontSize: 15).copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _cell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: bodyTextStyle(context, fontSize: 15),
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _actionCell(BuildContext context, String sppa1Id) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DnsppamvCariPage(sppa1Id: sppa1Id),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: const Text("View", style: TextStyle(fontSize: 12)),
      ),
    );
  }
}