import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/historybayar2cari_bloc.dart';
import 'package:joss_app/pages/payment/historybayar2cari_tile_widget.dart';
import 'package:joss_app/models/payment/historybayar2cari_model.dart';

class Historybayar2CariListWidget extends StatefulWidget {
	final String searchText;
	const Historybayar2CariListWidget({super.key, required this.searchText});

	@override
	Historybayar2CariListWidgetState createState() => Historybayar2CariListWidgetState();
}

class Historybayar2CariListWidgetState extends State<Historybayar2CariListWidget> {
	late Historybayar2CariBloc historybayar2CariBloc;
	List<Historybayar2CariModel> historybayar2Cari = [];
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
		historybayar2CariBloc = BlocProvider.of<Historybayar2CariBloc>(context);
		return BlocConsumer<Historybayar2CariBloc, Historybayar2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				historybayar2Cari.addAll(state.items);
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
								Historybayar2CariTileWidget(
									curr: state.items[index].curr,
									dn1Id: state.items[index].dn1Id,
									nilaiBayar: state.items[index].nilaiBayar,
									polisNo: state.items[index].polisNo,
									sppa1Id: state.items[index].sppa1Id,
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
			historybayar2CariBloc.add(FetchHistorybayar2CariEvent());
		}
	}

}
