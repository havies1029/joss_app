import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
import 'package:joss_app/pages/gen_klaim/klaim1list_tile_widget.dart';

import '../gen_klaim/klaim2list_main.dart';

class Klaim1ListListWidget extends StatefulWidget {
	final String searchText;
	const Klaim1ListListWidget({super.key, required this.searchText});

	@override
	Klaim1ListListWidgetState createState() => Klaim1ListListWidgetState();
}

class Klaim1ListListWidgetState extends State<Klaim1ListListWidget> {
	late Klaim1ListBloc klaim1ListBloc;
	late Klaim1CrudBloc klaim1CrudBloc;
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
		klaim1ListBloc = BlocProvider.of<Klaim1ListBloc>(context);
		klaim1CrudBloc = BlocProvider.of<Klaim1CrudBloc>(context);
		return BlocConsumer<Klaim1ListBloc, Klaim1ListState>(
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
												// 🔴 Progress (merah) -> buka Klaim 2 (tanpa param)
												SlidableAction(
													onPressed: (context) {
														Navigator.push(
															context,
															MaterialPageRoute(
																builder: (_) => Klaim2ListMainPage(
																	// key: state.items[index].klaim1Id, // kirim klaim1Id
																),
															),
														);
													},
													backgroundColor: Colors.red,
													foregroundColor: Colors.white,
													icon: Icons.timeline,
													label: "Progress",
												),

												// ✅ Edit (hijau)
												SlidableAction(
													onPressed: (context) {
														klaim1ListBloc.add(
															UbahKlaim1ListEvent(
																recordId: state.items[index].klaim1Id,
															),
														);
													},
													backgroundColor: Colors.green,
													icon: Icons.edit,
													label: "Edit",
												),

												// 🗑️ Delete (merah tua)
												SlidableAction(
													onPressed: (context) {
														showDialogHapus(state.items[index].klaim1Id);
													},
													backgroundColor: Colors.redAccent.shade700,
													foregroundColor: Colors.white,
													icon: Icons.delete,
													label: "Delete",
												),
											],
										),
										child: Klaim1ListTileWidget(
											insuranceName: state.items[index].insuranceName,
											insuredName: state.items[index].insuredName,
											kejadianLokasi: state.items[index].kejadianLokasi,
											kejadianTgl: state.items[index].kejadianTgl,
											klaimAmount: state.items[index].klaimAmount,
											klaim1Id: state.items[index].klaim1Id,
											rmatauangNama: state.items[index].rmatauangNama,
											rugiDesc: state.items[index].rugiDesc,
											statusNama: state.items[index].statusNama,
										),
									)

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
			klaim1ListBloc.add(FetchKlaim1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		klaim1CrudBloc.add(Klaim1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			klaim1ListBloc.add(CloseDialogKlaim1ListEvent());
		});
	}

}
