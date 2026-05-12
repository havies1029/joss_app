import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_hull/sppa2hullcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_hull/sppa2hullcari_list_widget.dart';

class Sppa2hullCariPage extends StatefulWidget {
	const Sppa2hullCariPage({super.key});

	@override
	Sppa2hullCariPageState createState() => Sppa2hullCariPageState();
}

class Sppa2hullCariPageState extends State<Sppa2hullCariPage> {
	late Sppa2hullCariBloc sppa2hullCariBloc;
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
		sppa2hullCariBloc = BlocProvider.of<Sppa2hullCariBloc>(context);
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
		sppa2hullCariBloc.add(
			RefreshSppa2hullCariEvent(sppa1Id: '', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2hullCariBloc.add(RefreshSppa2hullCariEvent(
				sppa1Id: '', searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2hullCariListWidget()],
		));
	}

}
