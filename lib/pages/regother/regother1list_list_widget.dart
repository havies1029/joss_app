import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/regother/regother1list_bloc.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/pages/regother/regother1list_tile_widget.dart';

class Regother1ListListWidget extends StatefulWidget {
	final String searchText;
	const Regother1ListListWidget({super.key, required this.searchText});

	@override
	Regother1ListListWidgetState createState() => Regother1ListListWidgetState();
}

class Regother1ListListWidgetState extends State<Regother1ListListWidget> {
	late Regother1ListBloc regother1ListBloc;
	late Regother1CrudBloc regother1CrudBloc;
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
		regother1ListBloc = BlocProvider.of<Regother1ListBloc>(context);
		regother1CrudBloc = BlocProvider.of<Regother1CrudBloc>(context);
		return BlocConsumer<Regother1ListBloc, Regother1ListState>(
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
															regother1ListBloc.add(
																UbahRegother1ListEvent(
																	recordId: state
																		.items[index]
																		.regother1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].regother1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Regother1ListTileWidget(
												cobNama: state.items[index].cobNama,
												regother1Id: state.items[index].regother1Id,
												remark: state.items[index].remark,
												rMATAUANGNAMA: state.items[index].rMATAUANGNAMA,
												tsi: state.items[index].tsi,
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
			regother1ListBloc.add(FetchRegother1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		regother1CrudBloc.add(Regother1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			regother1ListBloc.add(CloseDialogRegother1ListEvent());
		});
	}

}
