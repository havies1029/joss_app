import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_par/sppa2parcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_par/sppa2parcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_par/sppa2parcari_model.dart';

class Sppa2parCariListWidget extends StatefulWidget {
	const Sppa2parCariListWidget({super.key});

	@override
	Sppa2parCariListWidgetState createState() => Sppa2parCariListWidgetState();
}

class Sppa2parCariListWidgetState extends State<Sppa2parCariListWidget> {
	late Sppa2parCariBloc sppa2parCariBloc;
	List<Sppa2parCariModel> sppa2parCari = [];
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
		sppa2parCariBloc = BlocProvider.of<Sppa2parCariBloc>(context);
		return BlocConsumer<Sppa2parCariBloc, Sppa2parCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2parCari.addAll(state.items);
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
								Sppa2parCariTileWidget(
									lokasi1: state.items[index].lokasi1,
									lokasi2: state.items[index].lokasi2,
									okupasiDesc: state.items[index].okupasiDesc,
									premiNet: state.items[index].premiNet,
									sppa2parId: state.items[index].sppa2parId,
									tsiTotal: state.items[index].tsiTotal,
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
			sppa2parCariBloc.add(FetchSppa2parCariEvent());
		}
	}

}
