import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/calpar/calpar1list_bloc.dart';
import 'package:joss_app/blocs/calpar/calpar1crud_bloc.dart';
import 'package:joss_app/pages/calpar/calpar1list_tile_widget.dart';

class Calpar1ListListWidget extends StatefulWidget {
	final String searchText;
	const Calpar1ListListWidget({super.key, required this.searchText});

	@override
	Calpar1ListListWidgetState createState() => Calpar1ListListWidgetState();
}

class Calpar1ListListWidgetState extends State<Calpar1ListListWidget> {
	late Calpar1ListBloc calpar1ListBloc;
	late Calpar1CrudBloc calpar1CrudBloc;
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
		calpar1ListBloc = BlocProvider.of<Calpar1ListBloc>(context);
		calpar1CrudBloc = BlocProvider.of<Calpar1CrudBloc>(context);
		return BlocConsumer<Calpar1ListBloc, Calpar1ListState>(
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
															calpar1ListBloc.add(
																UbahCalpar1ListEvent(
																	recordId: state
																		.items[index]
																		.calpar1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].calpar1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Calpar1ListTileWidget(
												calpar1Id: state.items[index].calpar1Id,
												coverBulan: state.items[index].coverBulan,
												jenisNama: state.items[index].jenisNama,
												kelasNama: state.items[index].kelasNama,
												okupasiDesc: state.items[index].okupasiDesc,
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
			calpar1ListBloc.add(FetchCalpar1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		calpar1CrudBloc.add(Calpar1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			calpar1ListBloc.add(CloseDialogCalpar1ListEvent());
		});
	}

}
