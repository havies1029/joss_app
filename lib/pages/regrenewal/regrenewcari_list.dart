import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/regrenewal/regrenewcari_bloc.dart';
import 'package:joss_app/pages/regrenewal/regrenewcari_list_widget.dart';

class RegrenewCariPage extends StatefulWidget {
	const RegrenewCariPage({super.key});

	@override
	RegrenewCariPageState createState() => RegrenewCariPageState();
}

class RegrenewCariPageState extends State<RegrenewCariPage> {
	late RegrenewCariBloc regrenewCariBloc;
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
		regrenewCariBloc = BlocProvider.of<RegrenewCariBloc>(context);
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
		regrenewCariBloc.add(
			RefreshRegrenewCariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regrenewCariBloc.add(RefreshRegrenewCariEvent(
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[RegrenewCariListWidget(searchText: _searchController.text)],
		));
	}

}
