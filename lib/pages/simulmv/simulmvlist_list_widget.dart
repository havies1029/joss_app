import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/simulmv/simulmvlist_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/pages/simulmv/simulmvlist_tile_widget.dart';

class SimulmvListListWidget extends StatefulWidget {
	final String searchText;
	const SimulmvListListWidget({super.key, required this.searchText});

	@override
	SimulmvListListWidgetState createState() => SimulmvListListWidgetState();
}

class SimulmvListListWidgetState extends State<SimulmvListListWidget> {
	late SimulmvListBloc simulmvListBloc;
	late SimulmvCrudBloc simulmvCrudBloc;
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
		simulmvListBloc = BlocProvider.of<SimulmvListBloc>(context);
		simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);
		return BlocConsumer<SimulmvListBloc, SimulmvListState>(
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
															simulmvListBloc.add(
																UbahSimulmvListEvent(
																	recordId: state
																		.items[index]
																		.simulmv1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].simulmv1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: SimulmvListTileWidget(
												aw: state.items[index].aw,
												coverBulan: state.items[index].coverBulan,
												coverName: state.items[index].coverName,
												grupNama: state.items[index].grupNama,
												harga: state.items[index].harga,
												isEq: state.items[index].isEq,
												isFlood: state.items[index].isFlood,
												isSrcc: state.items[index].isSrcc,
												isTerrorism: state.items[index].isTerrorism,
												pad: state.items[index].pad,
												pap: state.items[index].pap,
												pARENTID: state.items[index].pARENTID,
												periodeAkhir: state.items[index].periodeAkhir,
												periodeMulai: state.items[index].periodeMulai,
												pll: state.items[index].pll,
												premiAdd: state.items[index].premiAdd,
												premiCasco: state.items[index].premiCasco,
												premiTotal: state.items[index].premiTotal,
												remarks: state.items[index].remarks,
												rMATAUANGNAMA: state.items[index].rMATAUANGNAMA,
												simulmv1Id: state.items[index].simulmv1Id,
												theinsured: state.items[index].theinsured,
												thnBuat: state.items[index].thnBuat,
												tpl: state.items[index].tpl,
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
			simulmvListBloc.add(FetchSimulmvListEvent());
		}
	}

	onHapusFunction(String recordId) {
		simulmvCrudBloc.add(SimulmvCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			simulmvListBloc.add(CloseDialogSimulmvListEvent());
		});
	}

}
