import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_dashboard/asetdashboardcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_dashboard/asetdashboardcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_dashboard/asetdashboardcari_model.dart';

class AsetDashboardCariListWidget extends StatefulWidget {
	const AsetDashboardCariListWidget({super.key});

	@override
	AsetDashboardCariListWidgetState createState() => AsetDashboardCariListWidgetState();
}

class AsetDashboardCariListWidgetState extends State<AsetDashboardCariListWidget> {
	late AsetDashboardCariBloc asetDashboardCariBloc;
	List<AsetDashboardCariModel> asetDashboardCari = [];
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
		asetDashboardCariBloc = BlocProvider.of<AsetDashboardCariBloc>(context);
		return BlocConsumer<AsetDashboardCariBloc, AsetDashboardCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asetDashboardCari.addAll(state.items);
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
								AsetDashboardCariTileWidget(
									aktifQty: state.items[index].aktifQty,
									berakhirQty: state.items[index].berakhirQty,
									nonAktifQty: state.items[index].nonAktifQty,
									onProgressQty: state.items[index].onProgressQty,
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
			asetDashboardCariBloc.add(FetchAsetDashboardCariEvent());
		}
	}

}
