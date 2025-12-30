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

  const RincianTablePage({super.key, required this.headers, required this.selectedIds, required this.onSelect, required this.onUnselect});

  @override
  State<RincianTablePage> createState() => _RincianTablePageState();
}

class _RincianTablePageState extends State<RincianTablePage> {

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.headers.length,
      itemBuilder: (context, index) {
        final header = widget.headers[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderTitle(header),
                const SizedBox(height: 12),
                _buildDetailTable(header.details),
                const SizedBox(height: 12),
                _buildFooterTable(header.footers),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================
  // HEADER TITLE
  // ============================
  Widget _buildHeaderTitle(DnHeaderCobModel header) {
    return Text(
      "Polis ${header.cobNama}",
      style: TextStyle(
        fontSize: getResponsiveFont(context, 18),
        color: primaryLightColor,
      ),
    );
  }

  Widget _buildDetailTable(List<DnDetailSppaModel> details) {
    if (details.isEmpty) {
      return const Text("Tidak ada detail polis");
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(3),
      },
      children: [
        _tableHeader([
          "",
          "No",
          "No Polis",
          "Object",
          "Curr",
          "Outstanding",
          "Periode",
        ]),
        ...details.map((d) => _detailRowWithCheckbox(d))
      ],
    );
  }

  // ============================
  // FOOTER SUMMARY TABLE
  // ============================
  Widget _buildFooterTable(List<DnFooterCobModel> footers) {
    if (footers.isEmpty) {
      return const Text("Tidak ada footer summary");
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
      },
      children: [
        _tableHeader([
          "Currency",
          "Total OS"
        ]),
        ...footers.map((f) => _tableRow([
          f.currSimbol,
          formatNum(f.totalOs),
        ])),
      ],
    );
  }


  // ============================
  // TABLE HELPERS
  // ============================
  TableRow _tableHeader(List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      children: cells
          .map(
            (text) => Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      )
          .toList(),
    );
  }

  TableRow _tableRow(List<String> cells) {
    return TableRow(
      children: cells
          .map(
            (text) => Padding(
          padding: const EdgeInsets.all(6),
          child: Text(text),
        ),
      )
          .toList(),
    );
  }

  TableRow _detailRowWithCheckbox(DnDetailSppaModel d) {
    final isSelected = widget.selectedIds.contains(d.dn1Id); // ambil dari BLoC state

    return TableRow(
      children: [
        // CHECKBOX CELL
        Padding(
          padding: const EdgeInsets.all(6),
          child: Checkbox(
            value: isSelected,
            onChanged: (checked) {
              if (checked == true) {
                widget.onSelect(d.dn1Id);   // kirim ke BLoC
              } else {
                widget.onUnselect(d.dn1Id); // kirim ke BLoC
              }
            },
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.rownumber.toString()),
        ),

        // NO POLIS
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.noPolis),
        ),

        // OBJECT DESC
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.objectDesc),
        ),

        // CURR
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.currSimbol),
        ),

        // OS
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(formatNum(d.dnOs)),
        ),

        // PERIODE
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            "${d.polisMulai.toString().substring(0, 10)} → "
                "${d.polisAkhir.toString().substring(0, 10)}",
          ),
        ),
      ],
    );
  }

}
