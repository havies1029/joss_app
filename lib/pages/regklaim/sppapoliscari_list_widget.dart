import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regklaim/sppapoliscari_bloc.dart';
import 'package:joss_app/pages/regklaim/sppapoliscari_tile_widget.dart';
import 'package:joss_app/models/regklaim/sppapoliscari_model.dart';

class SppapoliscariListWidget extends StatefulWidget {
	const SppapoliscariListWidget({super.key});

	@override
	SppapoliscariListWidgetState createState() => SppapoliscariListWidgetState();
}

class SppapoliscariListWidgetState extends State<SppapoliscariListWidget> {
	late SppapoliscariBloc sppapoliscariBloc;
	List<SppapoliscariModel> sppapoliscari = [];
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
		sppapoliscariBloc = BlocProvider.of<SppapoliscariBloc>(context);
		return BlocConsumer<SppapoliscariBloc, SppapoliscariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppapoliscari.addAll(state.items);
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
								SppapoliscariTileWidget(
									polisNo: state.items[index].polisNo,
									sppaId: state.items[index].sppaId,
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
			sppapoliscariBloc.add(FetchSppapoliscariEvent());
		}
	}

}
