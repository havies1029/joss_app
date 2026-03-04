import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/payment/historybayarcari_tile_widget.dart';
import 'package:joss_app/models/payment/historybayarcari_model.dart';

class HistorybayarCariListWidget extends StatefulWidget {
	const HistorybayarCariListWidget({super.key});

	@override
	HistorybayarCariListWidgetState createState() => HistorybayarCariListWidgetState();
}

class HistorybayarCariListWidgetState extends State<HistorybayarCariListWidget> {
	late HistorybayarCariBloc historybayarCariBloc;
	List<HistorybayarCariModel> historybayarCari = [];
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
		historybayarCariBloc = BlocProvider.of<HistorybayarCariBloc>(context);
		return BlocConsumer<HistorybayarCariBloc, HistorybayarCariState>(
				builder: (context, state) {
					if (state.status == ListStatus.success) {
						if (!state.hasReachedMax) {
							historybayarCari.addAll(state.items);
						}

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
												HistorybayarCariTileWidget(
														invTgl: state.items[index].invTgl,
														inv1Id: state.items[index].inv1Id,
														jmlPolis: state.items[index].jmlPolis,
														nomor: state.items[index].nomor,
														status: state.items[index].status,
														totalBayar: state.items[index].totalBayar,
														stsInvId: state.items[index].stsInvId
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
			historybayarCariBloc.add(FetchHistorybayarCariEvent());
		}
	}

}
