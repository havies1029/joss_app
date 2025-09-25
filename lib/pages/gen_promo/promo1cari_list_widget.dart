import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_promo/promo1cari_bloc.dart';
import 'package:joss_app/pages/gen_promo/promo1cari_tile_widget.dart';
import 'package:joss_app/models/gen_promo/promo1cari_model.dart';

class Promo1CariListWidget extends StatefulWidget {
	const Promo1CariListWidget({super.key});

	@override
	Promo1CariListWidgetState createState() => Promo1CariListWidgetState();
}

class Promo1CariListWidgetState extends State<Promo1CariListWidget> {
	late Promo1CariBloc promo1CariBloc;
	List<Promo1CariModel> promo1Cari = [];
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
		promo1CariBloc = BlocProvider.of<Promo1CariBloc>(context);
		return BlocConsumer<Promo1CariBloc, Promo1CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				promo1Cari.addAll(state.items);
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
								Promo1CariTileWidget(
									hargaSatuan: state.items[index].hargaSatuan,
									hargaStart: state.items[index].hargaStart,
									promo1Id: state.items[index].promo1Id,
									ringkasan: state.items[index].ringkasan,
									cobNama: state.items[index].cobNama,
									curr: state.items[index].curr,
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
			promo1CariBloc.add(FetchPromo1CariEvent());
		}
	}

}
