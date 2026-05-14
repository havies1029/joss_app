import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_mv/sppa2mvcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_mv/sppa2mvcari_list_widget.dart';

class Sppa2mvCariPage extends StatefulWidget {
	const Sppa2mvCariPage({super.key});

	@override
	Sppa2mvCariPageState createState() => Sppa2mvCariPageState();
}

class Sppa2mvCariPageState extends State<Sppa2mvCariPage> {
	late Sppa2mvCariBloc sppa2mvCariBloc;
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
		sppa2mvCariBloc = BlocProvider.of<Sppa2mvCariBloc>(context);
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
		sppa2mvCariBloc.add(
			RefreshSppa2mvCariEvent(searchText: _searchController.text, sppa1Id: ''));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppa2mvCariBloc.add(RefreshSppa2mvCariEvent(
				searchText: _searchController.text, sppa1Id: ''));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Sppa2mvCariListWidget()],
		));
	}

}
