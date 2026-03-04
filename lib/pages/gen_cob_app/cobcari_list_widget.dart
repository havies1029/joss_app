import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_cob_app/cobcari_bloc.dart';
import 'package:joss_app/pages/gen_cob_app/cobcari_tile_widget.dart';
import 'package:joss_app/models/gen_cob_app/cobcari_model.dart';

class CobCariListWidget extends StatefulWidget {
	final String searchText;
	const CobCariListWidget({super.key, required this.searchText});

	@override
	CobCariListWidgetState createState() => CobCariListWidgetState();
}

class CobCariListWidgetState extends State<CobCariListWidget> {
	late CobCariBloc cobCariBloc;
	List<CobCariModel> cobCari = [];
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
		cobCariBloc = BlocProvider.of<CobCariBloc>(context);
		return BlocConsumer<CobCariBloc, CobCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				cobCari.addAll(state.items);
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
								CobCariTileWidget(
									cobIcon: state.items[index].cobIcon,
									cobNama: state.items[index].cobNama,
									mCobApp1Id: state.items[index].mCobApp1Id,
									noUrut: state.items[index].noUrut,
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
			cobCariBloc.add(FetchCobCariEvent());
		}
	}

}
