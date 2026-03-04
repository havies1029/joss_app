import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_hull/asethullcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_hull/asethullcari_list_widget.dart';

class AsethullCariPage extends StatefulWidget {
	const AsethullCariPage({super.key});

	@override
	AsethullCariPageState createState() => AsethullCariPageState();
}

class AsethullCariPageState extends State<AsethullCariPage> {
	late AsethullCariBloc asethullCariBloc;
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
		asethullCariBloc = BlocProvider.of<AsethullCariBloc>(context);
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
		asethullCariBloc.add(
			RefreshAsethullCariEvent(searchText: _searchController.text, statusId: '10001'));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asethullCariBloc.add(RefreshAsethullCariEvent(
        searchText: _searchController.text, statusId: '10001'
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsethullCariListWidget(searchText: _searchController.text)],
		));
	}

}
