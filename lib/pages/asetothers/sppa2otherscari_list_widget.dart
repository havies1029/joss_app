import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/asetothers/sppa2otherscari_bloc.dart';
import 'package:joss_app/pages/asetothers/sppa2otherscari_tile_widget.dart';
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';

class Sppa2othersCariListWidget extends StatefulWidget {
	final String searchText;
	const Sppa2othersCariListWidget({super.key, required this.searchText});

	@override
	Sppa2othersCariListWidgetState createState() => Sppa2othersCariListWidgetState();
}

class Sppa2othersCariListWidgetState extends State<Sppa2othersCariListWidget> {
	late Sppa2othersCariBloc sppa2othersCariBloc;
	List<Sppa2othersCariModel> sppa2othersCari = [];
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
		sppa2othersCariBloc = BlocProvider.of<Sppa2othersCariBloc>(context);
		return BlocConsumer<Sppa2othersCariBloc, Sppa2othersCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				sppa2othersCari.addAll(state.items);
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
								Sppa2othersCariTileWidget(
									beginDate: state.items[index].beginDate,
									discNilai: state.items[index].discNilai,
									discPercent: state.items[index].discPercent,
									endDate: state.items[index].endDate,
									info1: state.items[index].info1,
									info2: state.items[index].info2,
									info3: state.items[index].info3,
									premiNet: state.items[index].premiNet,
									premiNilai: state.items[index].premiNilai,
									premiNilai1: state.items[index].premiNilai1,
									premiNilai2: state.items[index].premiNilai2,
									premiNilai3: state.items[index].premiNilai3,
									premiNilai4: state.items[index].premiNilai4,
									premiNilai5: state.items[index].premiNilai5,
									premiRate1: state.items[index].premiRate1,
									premiRate2: state.items[index].premiRate2,
									premiRate3: state.items[index].premiRate3,
									premiRate4: state.items[index].premiRate4,
									premiRate5: state.items[index].premiRate5,
									si1Desc: state.items[index].si1Desc,
									si1Nilai: state.items[index].si1Nilai,
									si2Desc: state.items[index].si2Desc,
									si2Nilai: state.items[index].si2Nilai,
									si3Desc: state.items[index].si3Desc,
									si3Nilai: state.items[index].si3Nilai,
									si4Desc: state.items[index].si4Desc,
									si4Nilai: state.items[index].si4Nilai,
									si5Desc: state.items[index].si5Desc,
									si5Nilai: state.items[index].si5Nilai,
									sppa1Id: state.items[index].sppa1Id,
									sppa2othersId: state.items[index].sppa2othersId,
									tsi: state.items[index].tsi,
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
			sppa2othersCariBloc.add(FetchSppa2othersCariEvent());
		}
	}

}
