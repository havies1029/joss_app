import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/simulpar/simulparlist_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/pages/simulpar/simulparlist_tile_widget.dart';

class SimulparListListWidget extends StatefulWidget {
	final String searchText;
	const SimulparListListWidget({super.key, required this.searchText});

	@override
	SimulparListListWidgetState createState() => SimulparListListWidgetState();
}

class SimulparListListWidgetState extends State<SimulparListListWidget> {
	late SimulparListBloc simulparListBloc;
	late SimulparCrudBloc simulparCrudBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		simulparListBloc = BlocProvider.of<SimulparListBloc>(context);
		simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);
		return BlocConsumer<SimulparListBloc, SimulparListState>(
			builder: (context, state) {
			if (state.status == ListStatus.success) {
			return state.items.isNotEmpty
				? Flexible(
					child: ListView.builder(
						padding: EdgeInsets.zero,
						controller: _scrollController,
						itemCount: state.items.length,
						itemBuilder: (_, index) => Container(
							margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
							padding: const EdgeInsets.all(0.2),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(15.0)),
							child: Column(
								children: <Widget>[
									Slidable(
										endActionPane: ActionPane(
											motion: const BehindMotion(),
												children: [
													SlidableAction(
														onPressed: (context) {
															simulparListBloc.add(
																UbahSimulparListEvent(
																	recordId: state
																		.items[index]
																		.simulpar1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].simulpar1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: SimulparListTileWidget(
												biIndexRate: state.items[index].biIndexRate,
												coverBulan: state.items[index].coverBulan,
												discNilai: state.items[index].discNilai,
												discPersen: state.items[index].discPersen,
												kabupaten: state.items[index].kabupaten,
												kelasNama: state.items[index].kelasNama,
												keterangan: state.items[index].keterangan,
												kriteria: state.items[index].kriteria,
												okupasiDesc: state.items[index].okupasiDesc,
												premiBi: state.items[index].premiBi,
												premiBiEqvet: state.items[index].premiBiEqvet,
												premiBiOther: state.items[index].premiBiOther,
												premiBiPar: state.items[index].premiBiPar,
												premiBiRsmdcc: state.items[index].premiBiRsmdcc,
												premiBiTsfwd: state.items[index].premiBiTsfwd,
												premiEqvet: state.items[index].premiEqvet,
												premiNet: state.items[index].premiNet,
												premiNonBi: state.items[index].premiNonBi,
												premiOther: state.items[index].premiOther,
												premiPar: state.items[index].premiPar,
												premiRsmdcc: state.items[index].premiRsmdcc,
												premiTotal: state.items[index].premiTotal,
												premiTsfwd: state.items[index].premiTsfwd,
												rateEqvet: state.items[index].rateEqvet,
												rateOther: state.items[index].rateOther,
												ratePar: state.items[index].ratePar,
												rateRsmdcc: state.items[index].rateRsmdcc,
												rateTotal: state.items[index].rateTotal,
												rateTsfwd: state.items[index].rateTsfwd,
												rMATAUANGNAMA: state.items[index].rMATAUANGNAMA,
												siBi: state.items[index].siBi,
												siBuilding: state.items[index].siBuilding,
												siContent: state.items[index].siContent,
												siMachinery: state.items[index].siMachinery,
												siOther: state.items[index].siOther,
												siStock: state.items[index].siStock,
												simulpar1Id: state.items[index].simulpar1Id,
												stockAdjustable: state.items[index].stockAdjustable,
												theinsured: state.items[index].theinsured,
												wilayahNama: state.items[index].wilayahNama,
											)),
							],
						),
					)),
				)
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
				return (current.status == ListStatus.success);
			}, listener: (context, state) {}
		);
	}
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			simulparListBloc.add(FetchSimulparListEvent());
		}
	}

	onHapusFunction(String recordId) {
		simulparCrudBloc.add(SimulparCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			simulparListBloc.add(CloseDialogSimulparListEvent());
		});
	}

}
