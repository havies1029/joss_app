import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/regreaktif/regreaktifcari_bloc.dart';
import 'package:joss_app/pages/regreaktif/regreaktifcari_list_widget.dart';

class RegreaktifCariPage extends StatefulWidget {
	const RegreaktifCariPage({super.key});

	@override
	RegreaktifCariPageState createState() => RegreaktifCariPageState();
}

class RegreaktifCariPageState extends State<RegreaktifCariPage> {
	late RegreaktifCariBloc regreaktifCariBloc;
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
		regreaktifCariBloc = BlocProvider.of<RegreaktifCariBloc>(context);
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
		regreaktifCariBloc.add(
			RefreshRegreaktifCariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regreaktifCariBloc.add(RefreshRegreaktifCariEvent(
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[RegreaktifCariListWidget(searchText: _searchController.text)],
		));
	}

}
