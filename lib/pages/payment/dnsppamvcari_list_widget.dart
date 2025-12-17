import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/dnsppamvcari_bloc.dart';
import 'package:joss_app/pages/payment/dnsppamvcari_tile_widget.dart';
import 'package:joss_app/models/payment/dnsppamvcari_model.dart';

class DnsppamvCariListWidget extends StatefulWidget {
	final String searchText;
	const DnsppamvCariListWidget({super.key, required this.searchText});

	@override
	DnsppamvCariListWidgetState createState() => DnsppamvCariListWidgetState();
}

class DnsppamvCariListWidgetState extends State<DnsppamvCariListWidget> {
	late DnsppamvCariBloc dnsppamvCariBloc;
	List<DnsppamvCariModel> dnsppamvCari = [];
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
		dnsppamvCariBloc = BlocProvider.of<DnsppamvCariBloc>(context);
		return BlocConsumer<DnsppamvCariBloc, DnsppamvCariState>(
			builder: (context, state) {
		if (state.status == ListStatus.success) {
			if (!state.hasReachedMax) {
				dnsppamvCari.addAll(state.items);
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
							DnsppamvCariTileWidget(
								coverNama: state.items[index].coverNama,
								currDesc: state.items[index].currDesc,
								dnOs: state.items[index].dnOs,
								dn1Id: state.items[index].dn1Id,
								insuredNama: state.items[index].insuredNama,
								jthTempo: state.items[index].jthTempo,
								merkNama: state.items[index].merkNama,
								modelNama: state.items[index].modelNama,
								mvgroupNama: state.items[index].mvgroupNama,
								noPolis: state.items[index].noPolis,
								penggunaanDesc: state.items[index].penggunaanDesc,
								polisAkhir: state.items[index].polisAkhir,
								polisMulai: state.items[index].polisMulai,
								sppa1Id: state.items[index].sppa1Id,
								stsBayar: state.items[index].stsBayar,
								thnBuat: state.items[index].thnBuat,
								tipeNama: state.items[index].tipeNama,
								wilayahNama: state.items[index].wilayahNama,
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
			dnsppamvCariBloc.add(FetchDnsppamvCariEvent());
		}
	}

}
