import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/historybayar2cari_bloc.dart';
import 'package:joss_app/pages/payment/historybayar2cari_list_widget.dart';

class Historybayar2CariPage extends StatefulWidget {
  final String inv1Id;
  const Historybayar2CariPage({super.key, required this.inv1Id}); 

	@override
	Historybayar2CariPageState createState() => Historybayar2CariPageState();
}

class Historybayar2CariPageState extends State<Historybayar2CariPage> {
	late Historybayar2CariBloc historybayar2CariBloc;
	final TextEditingController _searchController = TextEditingController();
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		historybayar2CariBloc = BlocProvider.of<Historybayar2CariBloc>(context);
		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					ListPageFilterBarUIWidget(
						searchController: _searchController,
						searchButton: buildSearchButton()),
					buildList()
				],

			),
		);
	}
	void refreshData() {
		historybayar2CariBloc.add(
			RefreshHistorybayar2CariEvent(inv1Id: widget.inv1Id));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			historybayar2CariBloc.add(RefreshHistorybayar2CariEvent(
        inv1Id: widget.inv1Id));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Historybayar2CariListWidget(searchText: _searchController.text)],
		));
	}

}
