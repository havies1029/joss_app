import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/layanan/mlayanan1cari_bloc.dart';
import 'package:joss_app/pages/layanan/mlayanan1cari_tile_widget.dart';
import 'package:joss_app/models/layanan/mlayanan1cari_model.dart';

class Mlayanan1CariListWidget extends StatefulWidget {
	const Mlayanan1CariListWidget({super.key});

	@override
	Mlayanan1CariListWidgetState createState() => Mlayanan1CariListWidgetState();
}

class Mlayanan1CariListWidgetState extends State<Mlayanan1CariListWidget> {
	late Mlayanan1CariBloc mlayanan1CariBloc;
	List<Mlayanan1CariModel> mlayanan1Cari = [];
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
		mlayanan1CariBloc = BlocProvider.of<Mlayanan1CariBloc>(context);
		return BlocConsumer<Mlayanan1CariBloc, Mlayanan1CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				mlayanan1Cari.addAll(state.items);
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
								Mlayanan1CariTileWidget(
									descText: state.items[index].descText,
									mlayanan1Id: state.items[index].mLayanan1Id,
									titleText: state.items[index].titleText,
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
			mlayanan1CariBloc.add(FetchMlayanan1CariEvent(mlayanan1Id: mlayanan1CariBloc.state.mlayanan1Id));
		}
	}

}
