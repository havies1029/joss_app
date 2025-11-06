import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_hull/asethullcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_hull/asethullcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_hull/asethullcari_model.dart';

class AsethullCariListWidget extends StatefulWidget {
	final String searchText;
	const AsethullCariListWidget({super.key, required this.searchText});

	@override
	AsethullCariListWidgetState createState() => AsethullCariListWidgetState();
}

class AsethullCariListWidgetState extends State<AsethullCariListWidget> {
	late AsethullCariBloc asethullCariBloc;
	List<AsethullCariModel> asethullCari = [];
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
		asethullCariBloc = BlocProvider.of<AsethullCariBloc>(context);
		return BlocConsumer<AsethullCariBloc, AsethullCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asethullCari.addAll(state.items);
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
								AsethullCariTileWidget(
									asetHullId: state.items[index].asetHullId,
									curr: state.items[index].curr,
									namaKapal: state.items[index].namaKapal,
									polisNo: state.items[index].polisNo,
									premi: state.items[index].premi,
									status: state.items[index].status,
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
			asethullCariBloc.add(FetchAsethullCariEvent());
		}
	}

}
