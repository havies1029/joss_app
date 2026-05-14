import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_health/sppa2healthcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_health/sppa2healthcari_list_widget.dart';

class Sppa2healthCariPage extends StatefulWidget {
	const Sppa2healthCariPage({super.key});

	@override
	Sppa2healthCariPageState createState() => Sppa2healthCariPageState();
}

class Sppa2healthCariPageState extends State<Sppa2healthCariPage> {
	late Sppa2healthCariBloc sppa2healthCariBloc;
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
		sppa2healthCariBloc = BlocProvider.of<Sppa2healthCariBloc>(context);
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
		sppa2healthCariBloc.add(
			RefreshSppa2healthCariEvent(searchText: _searchController.text, sppa1Id: ''));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2healthCariBloc.add(RefreshSppa2healthCariEvent(
				searchText: _searchController.text, sppa1Id: ''));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2healthCariListWidget()],
		));
	}

}
