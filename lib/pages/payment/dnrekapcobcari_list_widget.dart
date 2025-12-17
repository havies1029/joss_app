import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/pages/payment/dnrekapcobcari_tile_widget.dart';
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

class DnrekapcobCariListWidget extends StatefulWidget {
	final String searchText;
	const DnrekapcobCariListWidget({super.key, required this.searchText});

	@override
	DnrekapcobCariListWidgetState createState() => DnrekapcobCariListWidgetState();
}

class DnrekapcobCariListWidgetState extends State<DnrekapcobCariListWidget> {
	late DnrekapcobCariBloc dnrekapcobCariBloc;
	List<DnrekapcobCariModel> dnrekapcobCari = [];
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
		dnrekapcobCariBloc = BlocProvider.of<DnrekapcobCariBloc>(context);
		return BlocConsumer<DnrekapcobCariBloc, DnrekapcobCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				dnrekapcobCari.addAll(state.items);
			}

		return state.items.isNotEmpty
			? ListView.builder(
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
							DnrekapcobCariTileWidget(
								cobId: state.items[index].cobId,
								cobNama: state.items[index].cobNama,
								currId: state.items[index].currId,
								currSimbol: state.items[index].currSimbol,
								dnrekapcobId: state.items[index].dnrekapcobId,
								polisAmount: state.items[index].polisAmount,
								polisCount: state.items[index].polisCount,
                isChecked: state.selectedIds.contains(state.items[index].cobId),
                onChecked: (_) {
                  context.read<DnrekapcobCariBloc>().add(
                    ToggleSelectItemEvent(state.items[index].cobId),
                  );
                },

							)
						],
					),
				))
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
			dnrekapcobCariBloc.add(FetchDnrekapcobCariEvent());
		}
	}

}
