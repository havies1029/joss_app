import 'package:joss_app/models/payment/dndetailsppa_model.dart';
import 'package:joss_app/models/payment/dnfootercob_model.dart';
import 'package:joss_app/models/payment/dngrandtotal_model.dart';
import 'package:joss_app/models/payment/dnheadercob_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RincianSoaWidget extends StatelessWidget {
  final List<DnHeaderCobModel> headers;
  final List<DnGrandTotalModel> grandTotals;
  final List<String> selectedIds;
  final Function(String dn1Id) onSelect;
  final Function(String dn1Id) onUnselect;

  const RincianSoaWidget({super.key, required this.headers, required this.grandTotals, required this.selectedIds, required this.onSelect, required this.onUnselect});

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // =========================
        // LIST PER COB
        // =========================
        ...headers.map((header) => _buildCobCard(header)),

        // =========================
        // GRAND TOTAL (JOINED)
        // =========================
        if (grandTotals.isNotEmpty) _buildGrandTotalCard(grandTotals),
      ],
    );
  }

  // ============================
  // HEADER TITLE
  // ============================
  Widget _buildHeaderTitle(DnHeaderCobModel header) {
    return Text(
      "${header.cobNama} (COB: ${header.cobId})",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }

  // ============================
  // DETAIL TABLE
  // ============================
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
    final isSelected = selectedIds.contains(d.dn1Id); // ambil dari BLoC state

    return TableRow(
      children: [
        // CHECKBOX CELL
        Padding(
          padding: const EdgeInsets.all(6),
          child: Checkbox(
            value: isSelected,
            onChanged: (checked) {
              if (checked == true) {
                onSelect(d.dn1Id);   // kirim ke BLoC
              } else {
                onUnselect(d.dn1Id); // kirim ke BLoC
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

  Widget _buildCobCard(DnHeaderCobModel header) {
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
  }

  Widget _buildGrandTotalCard(List<DnGrandTotalModel> totals) {
    String formatNum(num value) =>
        NumberFormat.decimalPattern().format(value);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "GRAND TOTAL",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
              },
              children: [
                _tableHeader(["Currency", "Total Outstanding"]),
                ...totals.map(
                  (g) => _tableRow([
                    g.currSimbol,
                    formatNum(g.totalOs),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
