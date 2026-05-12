import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/assetdetail/sppa2cari_bloc.dart';
import 'package:joss_app/pages/assetdetail/sppa2cari_list_widget.dart';

class Sppa2CariPage extends StatefulWidget {
	const Sppa2CariPage({super.key});

	@override
	Sppa2CariPageState createState() => Sppa2CariPageState();
}

class Sppa2CariPageState extends State<Sppa2CariPage> {
	late Sppa2CariBloc sppa2CariBloc;
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
		sppa2CariBloc = BlocProvider.of<Sppa2CariBloc>(context);
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
		sppa2CariBloc.add(
			RefreshSppa2CariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2CariBloc.add(RefreshSppa2CariEvent(
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2CariListWidget(searchText: _searchController.text)],
		));
	}

}
