import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regreaktif/regreaktifcari_bloc.dart';
import 'package:joss_app/pages/regreaktif/regreaktifcari_tile_widget.dart';
import 'package:joss_app/models/regreaktif/regreaktifcari_model.dart';

class RegreaktifCariListWidget extends StatefulWidget {
	final String searchText;
	const RegreaktifCariListWidget({super.key, required this.searchText});

	@override
	RegreaktifCariListWidgetState createState() => RegreaktifCariListWidgetState();
}

class RegreaktifCariListWidgetState extends State<RegreaktifCariListWidget> {
	late RegreaktifCariBloc regreaktifCariBloc;
	List<RegreaktifCariModel> regreaktifCari = [];
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
		regreaktifCariBloc = BlocProvider.of<RegreaktifCariBloc>(context);
		return BlocConsumer<RegreaktifCariBloc, RegreaktifCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				regreaktifCari.addAll(state.items);
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
								RegreaktifCariTileWidget(
									isUbah: state.items[index].isUbah,
									notePerubahan: state.items[index].notePerubahan,
									reaktifTgl: state.items[index].reaktifTgl,
									regreaktif1Id: state.items[index].regreaktif1Id,
									sppa1Id: state.items[index].sppa1Id,
									insuranceName: state.items[index].insuranceName,
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
			regreaktifCariBloc.add(FetchRegreaktifCariEvent());
		}
	}

}
