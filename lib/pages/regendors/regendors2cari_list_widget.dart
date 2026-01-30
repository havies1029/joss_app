import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regendors/regendors2cari_bloc.dart';
import 'package:joss_app/pages/regendors/regendors2cari_tile_widget.dart';
import 'package:joss_app/models/regendors/regendors2cari_model.dart';

class Regendors2CariListWidget extends StatefulWidget {
	const Regendors2CariListWidget({super.key});

	@override
	Regendors2CariListWidgetState createState() => Regendors2CariListWidgetState();
}

class Regendors2CariListWidgetState extends State<Regendors2CariListWidget> {
	late Regendors2CariBloc regendors2CariBloc;
	List<Regendors2CariModel> regendors2Cari = [];
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
		regendors2CariBloc = BlocProvider.of<Regendors2CariBloc>(context);
		return BlocConsumer<Regendors2CariBloc, Regendors2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				regendors2Cari.addAll(state.items);
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
								Regendors2CariTileWidget(
									regendors2Id: state.items[index].regendors2Id,
									remarks: state.items[index].remarks,
									tglStatus: state.items[index].tglStatus,
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
			regendors2CariBloc.add(FetchRegendors2CariEvent());
		}
	}

}
