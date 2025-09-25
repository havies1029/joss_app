import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparlist_bloc.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'package:joss_app/pages/gen_sppapar/sppaparlist_tile_widget.dart';

class SppaparListListWidget extends StatefulWidget {
	final String searchText;
	const SppaparListListWidget({super.key, required this.searchText});

	@override
	SppaparListListWidgetState createState() => SppaparListListWidgetState();
}

class SppaparListListWidgetState extends State<SppaparListListWidget> {
	late SppaparListBloc sppaparListBloc;
	late SppaparCrudBloc sppaparCrudBloc;
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
		sppaparListBloc = BlocProvider.of<SppaparListBloc>(context);
		sppaparCrudBloc = BlocProvider.of<SppaparCrudBloc>(context);
		return BlocConsumer<SppaparListBloc, SppaparListState>(
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
															sppaparListBloc.add(
																UbahSppaparListEvent(
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
											child: SppaparListTileWidget(												
												insuredAlamat1: state.items[index].insuredAlamat1,
												insuredAlamat2: state.items[index].insuredAlamat2,
												insuredNama: state.items[index].insuredNama,
												kabupaten: state.items[index].kabupaten,
												kelasNama: state.items[index].kelasNama,												
												kODEPOSNO: state.items[index].kODEPOSNO,
												kriteria: state.items[index].kriteria,
												lokasi1: state.items[index].lokasi1,
												lokasi2: state.items[index].lokasi2,
												okupasiDesc: state.items[index].okupasiDesc,
												periodeAkhir: state.items[index].periodeAkhir,
												periodeMulai: state.items[index].periodeMulai,
												premiTotal: state.items[index].premiTotal,
												curr: state.items[index].curr,
												sppaTgl: state.items[index].sppaTgl,
												sppa1Id: state.items[index].sppa1Id,
												tsi: state.items[index].tsi,
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
			sppaparListBloc.add(FetchSppaparListEvent());
		}
	}

	onHapusFunction(String recordId) {
		sppaparCrudBloc.add(SppaparCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			sppaparListBloc.add(CloseDialogSppaparListEvent());
		});
	}

}
