import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/regpar/regpar1list_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/pages/regpar/regpar1list_tile_widget.dart';

class Regpar1ListListWidget extends StatefulWidget {
	final String searchText;
	const Regpar1ListListWidget({super.key, required this.searchText});

	@override
	Regpar1ListListWidgetState createState() => Regpar1ListListWidgetState();
}

class Regpar1ListListWidgetState extends State<Regpar1ListListWidget> {
	late Regpar1ListBloc regpar1ListBloc;
	late Regpar1CrudBloc regpar1CrudBloc;
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
		regpar1ListBloc = BlocProvider.of<Regpar1ListBloc>(context);
		regpar1CrudBloc = BlocProvider.of<Regpar1CrudBloc>(context);
		return BlocConsumer<Regpar1ListBloc, Regpar1ListState>(
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
															regpar1ListBloc.add(
																UbahRegpar1ListEvent(
																	recordId: state
																		.items[index]
																		.regpar1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].regpar1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Regpar1ListTileWidget(
												regpar1Id: state.items[index].regpar1Id,
												ttgAlamat: state.items[index].ttgAlamat,
												ttgNama: state.items[index].ttgNama,
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
			regpar1ListBloc.add(FetchRegpar1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		regpar1CrudBloc.add(Regpar1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			regpar1ListBloc.add(CloseDialogRegpar1ListEvent());
		});
	}

}
