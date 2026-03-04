import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/pay2cari_bloc.dart';
import 'package:joss_app/pages/payment/paymentcrud_page/pay2cari_tile_widget.dart';
import 'package:joss_app/models/payment/pay2cari_model.dart';

class Pay2CariListWidget extends StatefulWidget {
	const Pay2CariListWidget({super.key});

	@override
	Pay2CariListWidgetState createState() => Pay2CariListWidgetState();
}

class Pay2CariListWidgetState extends State<Pay2CariListWidget> {
	late Pay2CariBloc pay2CariBloc;
	List<Pay2CariModel> pay2Cari = [];
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
		pay2CariBloc = BlocProvider.of<Pay2CariBloc>(context);
		return BlocConsumer<Pay2CariBloc, Pay2CariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				pay2Cari.addAll(state.items);
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
							Pay2CariTileWidget(
								ar1Id: state.items[index].ar1Id,
								ar2Id: state.items[index].ar2Id,
								dnOs: state.items[index].dnOs,
								nourut: state.items[index].nourut,
								periodeAkhir: state.items[index].periodeAkhir,
								periodeMulai: state.items[index].periodeMulai,
								sppaNoref: state.items[index].sppaNoref,
								sppa1Id: state.items[index].sppa1Id,
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
			pay2CariBloc.add(FetchPay2CariEvent());
		}
	}

}
