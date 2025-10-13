import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_cob_app/cobcari_bloc.dart';
import 'package:joss_app/pages/gen_cob_app/cobcari_list_widget.dart';

class CobCariPage extends StatefulWidget {
	const CobCariPage({super.key});

	@override
	CobCariPageState createState() => CobCariPageState();
}

class CobCariPageState extends State<CobCariPage> {
	late CobCariBloc cobCariBloc;
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
		cobCariBloc = BlocProvider.of<CobCariBloc>(context);
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
		cobCariBloc.add(
			RefreshCobCariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			cobCariBloc.add(RefreshCobCariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[CobCariListWidget(searchText: _searchController.text)],
		));
	}

}
