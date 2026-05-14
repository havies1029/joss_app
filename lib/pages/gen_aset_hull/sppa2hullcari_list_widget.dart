import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_hull/sppa2hullcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_hull/sppa2hullcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_hull/sppa2hullcari_model.dart';

class Sppa2hullCariListWidget extends StatefulWidget {
	const Sppa2hullCariListWidget({super.key});

	@override
	Sppa2hullCariListWidgetState createState() => Sppa2hullCariListWidgetState();
}

class Sppa2hullCariListWidgetState extends State<Sppa2hullCariListWidget> {
	late Sppa2hullCariBloc sppa2hullCariBloc;
	List<Sppa2hullCariModel> sppa2hullCari = [];
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
		sppa2hullCariBloc = BlocProvider.of<Sppa2hullCariBloc>(context);
		return BlocConsumer<Sppa2hullCariBloc, Sppa2hullCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2hullCari.addAll(state.items);
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
								Sppa2hullCariTileWidget(
									kerangka: state.items[index].kerangka,
									namaKapal: state.items[index].namaKapal,
									premiNet: state.items[index].premiNet,
									si: state.items[index].si,
									sppa2hullId: state.items[index].sppa2hullId,
									vesselClass: state.items[index].vesselClass,
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
			sppa2hullCariBloc.add(FetchSppa2hullCariEvent());
		}
	}

}
