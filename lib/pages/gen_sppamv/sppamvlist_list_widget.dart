import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvlist_bloc.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvlist_tile_widget.dart';

class SppamvListListWidget extends StatefulWidget {
	final String searchText;
	const SppamvListListWidget({super.key, required this.searchText});

	@override
	SppamvListListWidgetState createState() => SppamvListListWidgetState();
}

class SppamvListListWidgetState extends State<SppamvListListWidget> {
	late SppamvListBloc sppamvListBloc;
	late SppamvCrudBloc sppamvCrudBloc;
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
		sppamvListBloc = BlocProvider.of<SppamvListBloc>(context);
		sppamvCrudBloc = BlocProvider.of<SppamvCrudBloc>(context);
		return BlocConsumer<SppamvListBloc, SppamvListState>(
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
															sppamvListBloc.add(
																UbahSppamvListEvent(
																	recordId: state
																		.items[index]
																		.sppa1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].sppa1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: SppamvListTileWidget(
												coverName: state.items[index].coverName,
												grupNama: state.items[index].grupNama,
												harga: state.items[index].harga,
												insuredNama: state.items[index].insuredNama,
												mesinNo: state.items[index].mesinNo,
												nmMerk: state.items[index].nmMerk,
												nmTipe: state.items[index].nmTipe,
												periodeAkhir: state.items[index].periodeAkhir,
												periodeMulai: state.items[index].periodeMulai,
												polisiNo: state.items[index].polisiNo,
												premiTotal: state.items[index].premiTotal,
												rangkaNo: state.items[index].rangkaNo,
												curr: state.items[index].curr,
												sppaTgl: state.items[index].sppaTgl,
												sppa1Id: state.items[index].sppa1Id,
												thnBuat: state.items[index].thnBuat,
												warnaDesc: state.items[index].warnaDesc,
												wilayahNama: state.items[index].wilayahNama,
                        ePolisId: state.items[index].ePolisId
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
			sppamvListBloc.add(FetchSppamvListEvent());
		}
	}

	onHapusFunction(String recordId) {
		sppamvCrudBloc.add(SppamvCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			sppamvListBloc.add(CloseDialogSppamvListEvent());
		});
	}

}
