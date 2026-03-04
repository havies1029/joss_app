import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/asetothers/asetotherscari_bloc.dart';
import 'package:joss_app/pages/asetothers/asetotherscari_tile_widget.dart';
import 'package:joss_app/models/asetothers/asetotherscari_model.dart';

class AsetothersCariListWidget extends StatefulWidget {
	final String searchText;
	const AsetothersCariListWidget({super.key, required this.searchText});

	@override
	AsetothersCariListWidgetState createState() => AsetothersCariListWidgetState();
}

class AsetothersCariListWidgetState extends State<AsetothersCariListWidget> {
	late AsetothersCariBloc asetothersCariBloc;
	List<AsetothersCariModel> asetothersCari = [];
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
		asetothersCariBloc = BlocProvider.of<AsetothersCariBloc>(context);
		return BlocConsumer<AsetothersCariBloc, AsetothersCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asetothersCari.addAll(state.items);
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
								AsetothersCariTileWidget(
									asetOthersId: state.items[index].asetOthersId,
									curr: state.items[index].curr,
									nomor: state.items[index].nomor,
									objectDesc: state.items[index].objectDesc,
									polisNo: state.items[index].polisNo,
									premi: state.items[index].premi,
									status: state.items[index].status,
									sumInsured: state.items[index].sumInsured,
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
			asetothersCariBloc.add(FetchAsetothersCariEvent());
		}
	}

}
