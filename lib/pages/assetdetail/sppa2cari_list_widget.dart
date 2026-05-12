import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/assetdetail/sppa2cari_bloc.dart';
import 'package:joss_app/pages/assetdetail/sppa2cari_tile_widget.dart';
import 'package:joss_app/models/assetdetail/sppa2cari_model.dart';

class Sppa2CariListWidget extends StatefulWidget {
	final String searchText;
	const Sppa2CariListWidget({super.key, required this.searchText});

	@override
	Sppa2CariListWidgetState createState() => Sppa2CariListWidgetState();
}

class Sppa2CariListWidgetState extends State<Sppa2CariListWidget> {
	late Sppa2CariBloc sppa2CariBloc;
	List<Sppa2CariModel> sppa2Cari = [];
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
		sppa2CariBloc = BlocProvider.of<Sppa2CariBloc>(context);
		return BlocConsumer<Sppa2CariBloc, Sppa2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2Cari.addAll(state.items);
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
								Sppa2CariTileWidget(
									currDesc: state.items[index].currDesc,
									keterangan: state.items[index].keterangan,
									objectDesc: state.items[index].objectDesc,
									premi: state.items[index].premi,
									sppa1Id: state.items[index].sppa1Id,
									sppa2Id: state.items[index].sppa2Id,
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
			sppa2CariBloc.add(FetchSppa2CariEvent());
		}
	}

}
