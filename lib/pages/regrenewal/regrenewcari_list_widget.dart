import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regrenewal/regrenewcari_bloc.dart';
import 'package:joss_app/pages/regrenewal/regrenewcari_tile_widget.dart';
import 'package:joss_app/models/regrenewal/regrenewcari_model.dart';

class RegrenewCariListWidget extends StatefulWidget {
	final String searchText;
	const RegrenewCariListWidget({super.key, required this.searchText});

	@override
	RegrenewCariListWidgetState createState() => RegrenewCariListWidgetState();
}

class RegrenewCariListWidgetState extends State<RegrenewCariListWidget> {
	late RegrenewCariBloc regrenewCariBloc;
	List<RegrenewCariModel> regrenewCari = [];
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
		regrenewCariBloc = BlocProvider.of<RegrenewCariBloc>(context);
		return BlocConsumer<RegrenewCariBloc, RegrenewCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				regrenewCari.addAll(state.items);
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
								RegrenewCariTileWidget(
									isUbah: state.items[index].isUbah,
									notePerubahan: state.items[index].notePerubahan,
									regrenew1Id: state.items[index].regrenew1Id,
									renewTgl: state.items[index].renewTgl,
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
			regrenewCariBloc.add(FetchRegrenewCariEvent());
		}
	}

}
