import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_health/asethealthcari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

class AsetHealthCariListWidget extends StatefulWidget {
	final String searchText;
	const AsetHealthCariListWidget({super.key, required this.searchText});

	@override
	AsetHealthCariListWidgetState createState() => AsetHealthCariListWidgetState();
}

class AsetHealthCariListWidgetState extends State<AsetHealthCariListWidget> {
	late AsetHealthCariBloc asetHealthCariBloc;
	List<AsetHealthCariModel> asetHealthCari = [];
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
		asetHealthCariBloc = BlocProvider.of<AsetHealthCariBloc>(context);
		return BlocConsumer<AsetHealthCariBloc, AsetHealthCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asetHealthCari.addAll(state.items);
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
								AsetHealthCariTileWidget(
									asethealthId: state.items[index].asethealthId,
									dob: state.items[index].dob,
									jnskel: state.items[index].jnskel,
									nama: state.items[index].nama,
									nomor: state.items[index].nomor,
									polisNo: state.items[index].polisNo,
									posisi: state.items[index].posisi,
									status: state.items[index].status,
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
			asetHealthCariBloc.add(FetchAsetHealthCariEvent());
		}
	}

}
