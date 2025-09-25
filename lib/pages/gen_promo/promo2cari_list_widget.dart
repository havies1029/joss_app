import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_promo/promo2cari_bloc.dart';
import 'package:joss_app/pages/gen_promo/promo2cari_tile_widget.dart';
import 'package:joss_app/models/gen_promo/promo2cari_model.dart';

class Promo2CariListWidget extends StatefulWidget {
	const Promo2CariListWidget({super.key});

	@override
	Promo2CariListWidgetState createState() => Promo2CariListWidgetState();
}

class Promo2CariListWidgetState extends State<Promo2CariListWidget> {
	late Promo2CariBloc promo2CariBloc;
	List<Promo2CariModel> promo2Cari = [];
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
		promo2CariBloc = BlocProvider.of<Promo2CariBloc>(context);
		return BlocConsumer<Promo2CariBloc, Promo2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				promo2Cari.addAll(state.items);
			}

		return state.items.isNotEmpty
			? ListView.builder(
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
							Promo2CariTileWidget(
								fitur: state.items[index].fitur,
								noUrut: state.items[index].noUrut,
								promo2Id: state.items[index].promo2Id,
							)
						],
					),
				))
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
			promo2CariBloc.add(FetchPromo2CariEvent());
		}
	}

}
