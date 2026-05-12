import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_mv/sppa2mvcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_mv/sppa2mvcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_mv/sppa2mvcari_model.dart';

class Sppa2mvCariListWidget extends StatefulWidget {
	const Sppa2mvCariListWidget({super.key});

	@override
	Sppa2mvCariListWidgetState createState() => Sppa2mvCariListWidgetState();
}

class Sppa2mvCariListWidgetState extends State<Sppa2mvCariListWidget> {
	late Sppa2mvCariBloc sppa2mvCariBloc;
	List<Sppa2mvCariModel> sppa2mvCari = [];
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
		sppa2mvCariBloc = BlocProvider.of<Sppa2mvCariBloc>(context);
		return BlocConsumer<Sppa2mvCariBloc, Sppa2mvCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2mvCari.addAll(state.items);
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
								Sppa2mvCariTileWidget(
									harga: state.items[index].harga,
									mesinNo: state.items[index].mesinNo,
									polisiNo: state.items[index].polisiNo,
									premiNet: state.items[index].premiNet,
									rangkaNo: state.items[index].rangkaNo,
									sppa2mvId: state.items[index].sppa2mvId,
									thnBuat: state.items[index].thnBuat,
									coverName: state.items[index].coverName,
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
			sppa2mvCariBloc.add(FetchSppa2mvCariEvent());
		}
	}

}
