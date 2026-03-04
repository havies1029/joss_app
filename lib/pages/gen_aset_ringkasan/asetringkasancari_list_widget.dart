import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_tile_widget.dart';
import 'package:joss_app/models/gen_aset_ringkasan/asetringkasancari_model.dart';

class AsetRingkasanCariListWidget extends StatefulWidget {
	final String searchText;
	const AsetRingkasanCariListWidget({super.key, required this.searchText});

	@override
	AsetRingkasanCariListWidgetState createState() => AsetRingkasanCariListWidgetState();
}

class AsetRingkasanCariListWidgetState extends State<AsetRingkasanCariListWidget> {
	late AsetRingkasanCariBloc asetRingkasanCariBloc;
	List<AsetRingkasanCariModel> asetRingkasanCari = [];
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
		asetRingkasanCariBloc = BlocProvider.of<AsetRingkasanCariBloc>(context);
		return BlocConsumer<AsetRingkasanCariBloc, AsetRingkasanCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				asetRingkasanCari.addAll(state.items);
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
								AsetRingkasanCariTileWidget(
									asetNama: state.items[index].asetNama,
									asetRingkasanId: state.items[index].asetRingkasanId,
									curr: state.items[index].curr,
									jmlAset: state.items[index].jmlAset,
									nilaiAset: state.items[index].nilaiAset,
									noUrut: state.items[index].noUrut,
									satuan: state.items[index].satuan,
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
			asetRingkasanCariBloc.add(FetchAsetRingkasanCariEvent());
		}
	}

}
