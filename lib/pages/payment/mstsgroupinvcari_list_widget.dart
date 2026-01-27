import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/mstsgroupinvcari_bloc.dart';
import 'package:joss_app/pages/payment/mstsgroupinvcari_tile_widget.dart';
import 'package:joss_app/models/payment/mstsgroupinvcari_model.dart';

class MstsgroupinvCariListWidget extends StatefulWidget {
	final String searchText;
	const MstsgroupinvCariListWidget({super.key, required this.searchText});

	@override
	MstsgroupinvCariListWidgetState createState() => MstsgroupinvCariListWidgetState();
}

class MstsgroupinvCariListWidgetState extends State<MstsgroupinvCariListWidget> {
	late MstsgroupinvCariBloc mstsgroupinvCariBloc;
	List<MstsgroupinvCariModel> mstsgroupinvCari = [];
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
		mstsgroupinvCariBloc = BlocProvider.of<MstsgroupinvCariBloc>(context);
		return BlocConsumer<MstsgroupinvCariBloc, MstsgroupinvCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				mstsgroupinvCari.addAll(state.items);
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
								MstsgroupinvCariTileWidget(
									mstsgroupinv1Id: state.items[index].mstsgroupinv1Id,
									noUrut: state.items[index].noUrut,
									stsgroupNama: state.items[index].stsgroupNama,
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
			mstsgroupinvCariBloc.add(FetchMstsgroupinvCariEvent());
		}
	}

}
