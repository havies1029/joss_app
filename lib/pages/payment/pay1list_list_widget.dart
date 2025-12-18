import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/payment/pay1list_bloc.dart';
import 'package:joss_app/blocs/payment/pay1crud_bloc.dart';
import 'package:joss_app/pages/payment/pay1list_tile_widget.dart';

class Pay1ListListWidget extends StatefulWidget {
	final String searchText;
	const Pay1ListListWidget({super.key, required this.searchText});

	@override
	Pay1ListListWidgetState createState() => Pay1ListListWidgetState();
}

class Pay1ListListWidgetState extends State<Pay1ListListWidget> {
	late Pay1ListBloc pay1ListBloc;
	late Pay1CrudBloc pay1CrudBloc;
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
		pay1ListBloc = BlocProvider.of<Pay1ListBloc>(context);
		pay1CrudBloc = BlocProvider.of<Pay1CrudBloc>(context);
		return BlocConsumer<Pay1ListBloc, Pay1ListState>(
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
															pay1ListBloc.add(
																UbahPay1ListEvent(
																	recordId: state
																		.items[index]
																		.ar1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].ar1Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Pay1ListTileWidget(
												arTgl: state.items[index].arTgl,
												ar1Id: state.items[index].ar1Id,
												sppaCount: state.items[index].sppaCount,
												totalOs: state.items[index].totalOs,
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
			pay1ListBloc.add(FetchPay1ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		pay1CrudBloc.add(Pay1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			pay1ListBloc.add(CloseDialogPay1ListEvent());
		});
	}

}
