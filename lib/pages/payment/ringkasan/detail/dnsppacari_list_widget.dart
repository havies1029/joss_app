import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/pages/payment/ringkasan/detail/dnsppacari_tile_widget.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';

class DnsppaCariListWidget extends StatefulWidget {
	const DnsppaCariListWidget({super.key});

	@override
	DnsppaCariListWidgetState createState() => DnsppaCariListWidgetState();
}

class DnsppaCariListWidgetState extends State<DnsppaCariListWidget> {
	late DnsppaCariBloc dnsppaCariBloc;
	List<DnsppaCariModel> dnsppaCari = [];
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
		dnsppaCariBloc = BlocProvider.of<DnsppaCariBloc>(context);
		return BlocConsumer<DnsppaCariBloc, DnsppaCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				dnsppaCari.addAll(state.items);
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
							DnsppaCariTileWidget(
								currSimbol: state.items[index].currSimbol,
								dnOs: state.items[index].dnOs,
								dn1Id: state.items[index].dn1Id,
								noPolis: state.items[index].noPolis,
								objectDesc: state.items[index].objectDesc,
								polisAkhir: state.items[index].polisAkhir,
								polisMulai: state.items[index].polisMulai,
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
			dnsppaCariBloc.add(FetchDnsppaCariEvent());
		}
	}

}
