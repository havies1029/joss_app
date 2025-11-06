import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1list_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/pages/gen_calmv/calmv1list_tile_widget.dart';

class Calmv1ListListWidget extends StatefulWidget {
	final String searchText;
	const Calmv1ListListWidget({super.key, required this.searchText});

	@override
	Calmv1ListListWidgetState createState() => Calmv1ListListWidgetState();
}

class Calmv1ListListWidgetState extends State<Calmv1ListListWidget> {
	late Calmv1ListBloc calmv1ListBloc;
	late Calmv1CrudBloc calmv1CrudBloc;
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
		calmv1ListBloc = BlocProvider.of<Calmv1ListBloc>(context);
		calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);
		return BlocConsumer<Calmv1ListBloc, Calmv1ListState>(
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
															calmv1ListBloc.add(
																UbahCalmv1ListEvent(
																	recordId: state
																		.items[index]
																		.calmv1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].calmv1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Calmv1ListTileWidget(
												calmv1Id: state.items[index].calmv1Id,
												coverBulan: state.items[index].coverBulan,
												coverName: state.items[index].coverName,
												currId: state.items[index].currId,
												grupNama: state.items[index].grupNama,
												harga: state.items[index].harga,
												thnBuat: state.items[index].thnBuat,
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
			calmv1ListBloc.add(FetchCalmv1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		calmv1CrudBloc.add(Calmv1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			calmv1ListBloc.add(CloseDialogCalmv1ListEvent());
		});
	}

}
