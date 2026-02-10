import 'package:joss_app/models/klaimrasio/klaimrasiocobcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiodetailcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiograndcurrcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiosumcurrcari_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrasio/klaimrasiocobcari_bloc.dart';
import 'package:intl/intl.dart';

class KlaimrasiocobCariListWidget extends StatefulWidget {
	const KlaimrasiocobCariListWidget({super.key});

	@override
	KlaimrasiocobCariListWidgetState createState() => KlaimrasiocobCariListWidgetState();
}

class KlaimrasiocobCariListWidgetState extends State<KlaimrasiocobCariListWidget> {
	late KlaimrasiocobCariBloc klaimrasiocobCariBloc;

	@override
	Widget build(BuildContext context) {
		klaimrasiocobCariBloc = BlocProvider.of<KlaimrasiocobCariBloc>(context);
		return BlocConsumer<KlaimrasiocobCariBloc, KlaimrasiocobCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {

      return state.klaimRasio.cobs.isNotEmpty
        ? ListView(
        children: [
          // =========================
          // LIST PER COB
          // =========================
          ...state.klaimRasio.cobs.map((header) => _buildCobCard(header)),

          // =========================
          // GRAND TOTAL (JOINED)
          // =========================
          if (state.klaimRasio.grandcurrs.isNotEmpty) _buildGrandTotalCard(state.klaimRasio.grandcurrs),
        ],
      )
        : const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.0),
            child: Text(
              'No Data Available x!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
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
                fontWeight: FontWeight.bold),
            ),
          );
        }
			}, buildWhen: (previous, current) {
				return (current.status == ListStatus.success);
			}, listener: (context, state) {}
		);
	}

  Widget _buildCobCard(KlaimrasiocobCariModel header) {
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



  // ============================
  // HEADER TITLE
  // ============================
  Widget _buildHeaderTitle(KlaimrasiocobCariModel header) {
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
  Widget _buildDetailTable(List<KlaimrasiodetailCariModel> details) {
    if (details.isEmpty) {
      return const Text("Tidak ada detail polis");
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1), 
        1: FlexColumnWidth(3), 
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(3),
        5: FlexColumnWidth(3),
        6: FlexColumnWidth(2),
      },
      children: [
        _tableHeader([
          "No",
          "No Polis",
          "Periode Polis",
          "Curr",
          "Premi",
          "Klaim",
          "Rasio",
        ]),
        ...details.map((d) => _detailRow(d))
      ],
    );
  }

  // ============================
  // FOOTER SUMMARY TABLE
  // ============================
  Widget _buildFooterTable(List<KlaimrasiosumcurrCariModel> footers) {
    if (footers.isEmpty) {
      return const Text("Tidak ada footer summary");
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(3),
      },
      children: [
        _tableHeader([
          "Curr",
          "Premi",
          "Klaim",
          "Rasio",
        ]),
        ...footers.map((f) => _tableRow([
              f.curr,
              formatNum(f.premiAmount),
              formatNum(f.klaimAmount),
              "${formatNum(f.rasio)}%",
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

  TableRow _detailRow(KlaimrasiodetailCariModel d) {

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.nourut.toString()),
        ),

        // NO POLIS
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.polisNo),
        ),

        // Periode Polis
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text("${d.periodeMulai.toString().substring(0, 10)} - ${d.periodeAkhir.toString().substring(0, 10)}"),
        ),

        // CURR
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.curr),
        ),

        // Premi
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(formatNum(d.premiAmount)),
        ),

        // Klaim
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(formatNum(d.klaimAmount)),
        ),

        // Rasio
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text("${formatNum(d.rasio)}%"),
        ),
      ],
    );
  }

  String formatNum(num value) {
    return NumberFormat.decimalPattern().format(value);
  }

  Widget _buildGrandTotalCard(List<KlaimrasiograndcurrCariModel> totals) {

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
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              children: [
                _tableHeader(["Curr", "Premi", "Klaim", "Rasio"]),
                ...totals.map(
                  (g) => _tableRow([
                    g.curr,
                    formatNum(g.premiAmount),
                    formatNum(g.klaimAmount),
                    "${formatNum(g.rasio)}%",
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
