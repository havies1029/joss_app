import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/asetothers/sppa2otherscari_bloc.dart';
import 'package:joss_app/pages/asetothers/sppa2otherscari_tile_widget.dart';
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';

class Sppa2othersCariListWidget extends StatefulWidget {
	const Sppa2othersCariListWidget({super.key});

	@override
	Sppa2othersCariListWidgetState createState() => Sppa2othersCariListWidgetState();
}

class Sppa2othersCariListWidgetState extends State<Sppa2othersCariListWidget> {
	late Sppa2othersCariBloc sppa2othersCariBloc;
	List<Sppa2othersCariModel> sppa2othersCari = [];
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
		sppa2othersCariBloc = BlocProvider.of<Sppa2othersCariBloc>(context);
		return BlocConsumer<Sppa2othersCariBloc, Sppa2othersCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2othersCari.addAll(state.items);
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
								Sppa2othersCariTileWidget(
									info1: state.items[index].info1,
									info2: state.items[index].info2,
									info3: state.items[index].info3,
									premiNet: state.items[index].premiNet,
									curr: state.items[index].curr,
									sppa2othersId: state.items[index].sppa2othersId,
									tsi: state.items[index].tsi,
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
			sppa2othersCariBloc.add(FetchSppa2othersCariEvent());
		}
	}

}
