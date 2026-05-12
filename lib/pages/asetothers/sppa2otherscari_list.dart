import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/asetothers/sppa2otherscari_bloc.dart';
import 'package:joss_app/pages/asetothers/sppa2otherscari_list_widget.dart';

class Sppa2othersCariPage extends StatefulWidget {
	const Sppa2othersCariPage({super.key});

	@override
	Sppa2othersCariPageState createState() => Sppa2othersCariPageState();
}

class Sppa2othersCariPageState extends State<Sppa2othersCariPage> {
	late Sppa2othersCariBloc sppa2othersCariBloc;
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
		sppa2othersCariBloc = BlocProvider.of<Sppa2othersCariBloc>(context);
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
		sppa2othersCariBloc.add(
			RefreshSppa2othersCariEvent(searchText: _searchController.text, hal: 0));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2othersCariBloc.add(RefreshSppa2othersCariEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2othersCariListWidget(searchText: _searchController.text)],
		));
	}

}
