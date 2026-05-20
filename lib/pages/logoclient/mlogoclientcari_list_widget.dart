import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/logoclient/mlogoclientcari_bloc.dart';
import 'package:joss_app/pages/logoclient/mlogoclientcari_tile_widget.dart';
import 'package:joss_app/models/logoclient/mlogoclientcari_model.dart';

class MlogoclientCariListWidget extends StatefulWidget {
	final String searchText;
	const MlogoclientCariListWidget({super.key, required this.searchText});

	@override
	MlogoclientCariListWidgetState createState() => MlogoclientCariListWidgetState();
}

class MlogoclientCariListWidgetState extends State<MlogoclientCariListWidget> {
	late MlogoclientCariBloc mlogoclientCariBloc;
	List<MlogoclientCariModel> mlogoclientCari = [];
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
		mlogoclientCariBloc = BlocProvider.of<MlogoclientCariBloc>(context);
		return BlocConsumer<MlogoclientCariBloc, MlogoclientCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				mlogoclientCari.addAll(state.items);
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
								MlogoclientCariTileWidget(
									isActive: state.items[index].isActive,
									linkUrl: state.items[index].linkUrl,
									logoNama: state.items[index].logoNama,
									logoSvg: state.items[index].logoSvg,
									mlogoclientId: state.items[index].mlogoclientId,
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
			mlogoclientCariBloc.add(FetchMlogoclientCariEvent());
		}
	}

}
