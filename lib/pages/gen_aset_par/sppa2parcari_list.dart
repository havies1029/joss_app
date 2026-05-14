import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_par/sppa2parcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_par/sppa2parcari_list_widget.dart';

class Sppa2parCariPage extends StatefulWidget {
	const Sppa2parCariPage({super.key});

	@override
	Sppa2parCariPageState createState() => Sppa2parCariPageState();
}

class Sppa2parCariPageState extends State<Sppa2parCariPage> {
	late Sppa2parCariBloc sppa2parCariBloc;
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
		sppa2parCariBloc = BlocProvider.of<Sppa2parCariBloc>(context);
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
		sppa2parCariBloc.add(
			RefreshSppa2parCariEvent(sppa1Id: '', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2parCariBloc.add(RefreshSppa2parCariEvent(
				sppa1Id: '', searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2parCariListWidget()],
		));
	}

}
