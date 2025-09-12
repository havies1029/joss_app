import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_klaim/klaim2list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim2crud_bloc.dart';
import 'package:joss_app/pages/gen_klaim/klaim2list_tile_widget.dart';

class Klaim2ListListWidget extends StatefulWidget {
	final String searchText;
	const Klaim2ListListWidget({super.key, required this.searchText});

	@override
	Klaim2ListListWidgetState createState() => Klaim2ListListWidgetState();
}

class Klaim2ListListWidgetState extends State<Klaim2ListListWidget> {
	late Klaim2ListBloc klaim2ListBloc;
	late Klaim2CrudBloc klaim2CrudBloc;
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
		klaim2ListBloc = BlocProvider.of<Klaim2ListBloc>(context);
		klaim2CrudBloc = BlocProvider.of<Klaim2CrudBloc>(context);
		return BlocConsumer<Klaim2ListBloc, Klaim2ListState>(
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
															klaim2ListBloc.add(
																UbahKlaim2ListEvent(
																	recordId: state
																		.items[index]
																		.klaim2Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].klaim2Id);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: Klaim2ListTileWidget(
												keterangan: state.items[index].keterangan,
												klaimAmountBaru: state.items[index].klaimAmountBaru,
												klaimAmountLama: state.items[index].klaimAmountLama,
												klaim2Id: state.items[index].klaim2Id,
												perubahanTgl: state.items[index].perubahanTgl,
												statusNama: state.items[index].statusNama,
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
			klaim2ListBloc.add(FetchKlaim2ListEvent());
		}
	}

	onHapusFunction(String recordId) {
		klaim2CrudBloc.add(Klaim2CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			klaim2ListBloc.add(CloseDialogKlaim2ListEvent());
		});
	}

}
