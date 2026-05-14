import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_health/sppa2healthcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_health/sppa2healthcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_health/sppa2healthcari_model.dart';

class Sppa2healthCariListWidget extends StatefulWidget {
	const Sppa2healthCariListWidget({super.key});

	@override
	Sppa2healthCariListWidgetState createState() => Sppa2healthCariListWidgetState();
}

class Sppa2healthCariListWidgetState extends State<Sppa2healthCariListWidget> {
	late Sppa2healthCariBloc sppa2healthCariBloc;
	List<Sppa2healthCariModel> sppa2healthCari = [];
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
		sppa2healthCariBloc = BlocProvider.of<Sppa2healthCariBloc>(context);
		return BlocConsumer<Sppa2healthCariBloc, Sppa2healthCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2healthCari.addAll(state.items);
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
								Sppa2healthCariTileWidget(									
									nama: state.items[index].nama,
									premiNet: state.items[index].premiNet,
									sppa2healthId: state.items[index].sppa2healthId,
									tsi: state.items[index].tsi,
									paketNama: state.items[index].paketNama,
								),
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
			sppa2healthCariBloc.add(FetchSppa2healthCariEvent());
		}
	}

}
