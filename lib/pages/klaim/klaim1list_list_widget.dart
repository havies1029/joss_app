import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaim/klaim1list_bloc.dart';
import 'package:joss_app/pages/klaim/klaim1list_tile_widget.dart';

class Klaim1ListListWidget extends StatefulWidget {
	final String searchText;
	const Klaim1ListListWidget({super.key, required this.searchText});

	@override
	Klaim1ListListWidgetState createState() => Klaim1ListListWidgetState();
}

class Klaim1ListListWidgetState extends State<Klaim1ListListWidget> {
	late Klaim1ListBloc klaim1ListBloc;
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
													SlidableAction(
														onPressed: (context) {
															klaim1ListBloc.add(
																TrackKlaim1ListEvent(
																	klaim1Id: state
																		.items[index]
																		.klaim1Id));
														},
														backgroundColor: Colors.green,
														icon: Icons.edit,
														label: "View Progress",
													),													
												]),
											child: Klaim1ListTileWidget(
												insuranceName: state.items[index].insuranceName,
												insuredName: state.items[index].insuredName,
												kejadianLokasi: state.items[index].kejadianLokasi,
												kejadianTgl: state.items[index].kejadianTgl,
												klaimAmount: state.items[index].klaimAmount,
												klaim1Id: state.items[index].klaim1Id,
												currDesc: state.items[index].currDesc,
												rugiDesc: state.items[index].rugiDesc,
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
			klaim1ListBloc.add(FetchKlaim1ListEvent());
		}
	}
}
