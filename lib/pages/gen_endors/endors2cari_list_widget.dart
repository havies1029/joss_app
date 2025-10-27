import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
import 'package:joss_app/pages/gen_endors/endors2cari_tile_widget.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';

class Endors2CariListWidget extends StatefulWidget {
	final String searchText;
	const Endors2CariListWidget({super.key, required this.searchText});

	@override
	Endors2CariListWidgetState createState() => Endors2CariListWidgetState();
}

class Endors2CariListWidgetState extends State<Endors2CariListWidget> {
	late Endors2CariBloc endors2CariBloc;
	List<Endors2CariModel> endors2Cari = [];
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
		endors2CariBloc = BlocProvider.of<Endors2CariBloc>(context);
		return BlocConsumer<Endors2CariBloc, Endors2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				endors2Cari.addAll(state.items);
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
								Endors2CariTileWidget(
									endors2Id: state.items[index].endors2Id,
									statusEndors: state.items[index].statusEndors,
									statusTgl: state.items[index].statusTgl,
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
			endors2CariBloc.add(FetchEndors2CariEvent());
		}
	}

}
