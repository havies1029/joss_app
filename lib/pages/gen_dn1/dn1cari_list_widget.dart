import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_dn1/dn1cari_bloc.dart';
import 'package:joss_app/pages/gen_dn1/dn1cari_tile_widget.dart';
import 'package:joss_app/models/gen_dn1/dn1cari_model.dart';

class Dn1CariListWidget extends StatefulWidget {
	final String searchText;
	const Dn1CariListWidget({super.key, required this.searchText});

	@override
	Dn1CariListWidgetState createState() => Dn1CariListWidgetState();
}

class Dn1CariListWidgetState extends State<Dn1CariListWidget> {
	late Dn1CariBloc dn1CariBloc;
	List<Dn1CariModel> dn1Cari = [];
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
		dn1CariBloc = BlocProvider.of<Dn1CariBloc>(context);
		return BlocConsumer<Dn1CariBloc, Dn1CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				dn1Cari.addAll(state.items);
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
								Dn1CariTileWidget(
									curr: state.items[index].curr,
									dnNilai: state.items[index].dnNilai,
									dn1Id: state.items[index].dn1Id,
									jthTempo: state.items[index].jthTempo,
									stsLunas: state.items[index].stsLunas,
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
			dn1CariBloc.add(FetchDn1CariEvent());
		}
	}

}
