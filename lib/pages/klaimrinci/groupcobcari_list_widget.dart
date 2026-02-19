import 'package:joss_app/models/klaimrinci/groupcobcari_model.dart';
import 'package:joss_app/models/klaimrinci/klaimdetailcari_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:intl/intl.dart';

class GroupcobCariListWidget extends StatefulWidget {
	const GroupcobCariListWidget({super.key});

	@override
	GroupcobCariListWidgetState createState() => GroupcobCariListWidgetState();
}

class GroupcobCariListWidgetState extends State<GroupcobCariListWidget> {
	late GroupcobCariBloc groupcobCariBloc;
  late List<String> selectedIds;

	@override
	Widget build(BuildContext context) {
		groupcobCariBloc = BlocProvider.of<GroupcobCariBloc>(context);
    selectedIds = [];
		return BlocConsumer<GroupcobCariBloc, GroupcobCariState>(
			builder: (context, state) {
      if (state.status == ListStatus.success) {

      selectedIds = groupcobCariBloc.state.selectedIds;
      return state.items.isNotEmpty
        ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.items.length,
          itemBuilder: (_, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            padding: const EdgeInsets.all(0.2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0)),
            child: _buildCobCard(state.items[index]),
          ))
        : const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.0),
            child: Text(
              'No Data Available!!',
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
              'No Data Available!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
            ),
          );
        }
			}, buildWhen: (previous, current) {
				return (current.status == ListStatus.success || previous.selectedIds != current.selectedIds);
			}, listener: (context, state) {}
		);
	}
	
  Widget _buildCobCard(GroupcobCariModel header) {
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
          ],
        ),
      ),
    );
  }

  // ============================
  // HEADER TITLE
  // ============================
  Widget _buildHeaderTitle(GroupcobCariModel header) {
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
  Widget _buildDetailTable(List<KlaimdetailCariModel> details) {
    if (details.isEmpty) {
      return const Text("Tidak ada detail klaim");
    }

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1), 
        1: FlexColumnWidth(1), 
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(3),
      },
      children: [
        _tableHeader([
          "",
          "No",
          "No Klaim",
          "No Polis",
          "Tanggal Kejadian",
          "Estimasi",
        ]),
        ...details.map((d) => _detailRowWithCheckbox(d))
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

  TableRow _detailRowWithCheckbox(KlaimdetailCariModel d) {
    final isSelected = selectedIds.contains(d.klaim1Id); // ambil dari BLoC state

    return TableRow(
      children: [
        // CHECKBOX CELL
        Padding(
          padding: const EdgeInsets.all(6),
          child: Checkbox(
            value: isSelected,
            onChanged: (checked) {
              if (checked == true) {
                groupcobCariBloc.add(SelectDetailEvent(d.klaim1Id));   // kirim ke BLoC
                groupcobCariBloc.add(SelectKlaimRecordEvent(d));
              } else {
                groupcobCariBloc.add(UnselectDetailEvent(d.klaim1Id)); // kirim ke BLoC
              }
            },
          ),
        ),

        // NO
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.nourut.toString()),
        ),

        // NO KLAIM
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.klaim1Id),
        ),

        // NO POLIS
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.noPolis),
        ),

        // TANGGAL KEJADIAN
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(d.tglKejadian.toString().substring(0, 10)),
        ),

        // ESTIMASI
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text("${d.curr} ${formatNum(d.klaimAmount)}"),
        ),
      ],
    );
  }

    String formatNum(num value) {
      return NumberFormat.decimalPattern().format(value);
    }

}
