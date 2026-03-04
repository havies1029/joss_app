import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../blocs/gen_profile/mrekanbankcrud_bloc.dart';
import '../../blocs/gen_profile/mrekanbanklist_bloc.dart';
import '../../common/constants.dart';
import '../../widgets/showdialoghapus_widget.dart';
import 'mrekanbanklist_tile_widget.dart';

class MRekanBankListListWidget extends StatefulWidget {
	final String searchText;
	const MRekanBankListListWidget({super.key, required this.searchText});

	@override
	MRekanBankListListWidgetState createState() => MRekanBankListListWidgetState();
}

class MRekanBankListListWidgetState extends State<MRekanBankListListWidget> {
	late MRekanBankListBloc mRekanBankListBloc;
	late MRekanBankCrudBloc mRekanBankCrudBloc;
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
		mRekanBankListBloc = BlocProvider.of<MRekanBankListBloc>(context);
		mRekanBankCrudBloc = BlocProvider.of<MRekanBankCrudBloc>(context);
		return BlocConsumer<MRekanBankListBloc, MRekanBankListState>(
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
															mRekanBankListBloc.add(
																UbahMRekanBankListEvent(
																	recordId: state
																		.items[index]
																		.mrekanbankId));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "Edit",
													),
													SlidableAction(
														onPressed: (context) {
															showDialogHapus(
																state.items[index].mrekanbankId);
														},
														backgroundColor: Colors.red,
														icon: Icons.delete,
														label: "Delete",
													),
												]),
											child: MRekanBankListTileWidget(
												bankNama: state.items[index].bankNama,
												mrekan1Id: state.items[index].mrekan1Id,
												mrekanbankId: state.items[index].mrekanbankId,
												rekNama: state.items[index].rekNama,
												rekNo: state.items[index].rekNo,
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
			mRekanBankListBloc.add(FetchMRekanBankListEvent());
		}
	}

	onHapusFunction(String recordId) {
		mRekanBankCrudBloc.add(MRekanBankCrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(onHapusFunction: onHapusFunction, recordId: recordId);
			}
		).then((value) {
			mRekanBankListBloc.add(CloseDialogMRekanBankListEvent());
		});
	}

}
