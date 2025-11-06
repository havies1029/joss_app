import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
import 'package:joss_app/pages/gen_endors/endors2cari_list_widget.dart';

class Endors2CariPage extends StatefulWidget {
	final String sppa1Id;
	const Endors2CariPage({super.key, required this.sppa1Id});

	@override
	Endors2CariPageState createState() => Endors2CariPageState();
}

class Endors2CariPageState extends State<Endors2CariPage> {
	late Endors2CariBloc endors2CariBloc;
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
		endors2CariBloc = BlocProvider.of<Endors2CariBloc>(context);
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
		endors2CariBloc.add(
				RefreshEndors2CariEvent(sppa1Id: widget.sppa1Id));
	}

	IconButton buildSearchButton() {
		return IconButton(
				icon: const Icon(
					Icons.autorenew_rounded,
					size: 35.0,
				),
				onPressed: () {
					endors2CariBloc.add(RefreshEndors2CariEvent(sppa1Id: widget.sppa1Id
					));
				});
	}

	Widget buildList() {
		return Expanded(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[Endors2CariListWidget(searchText: _searchController.text)],
				));
	}

}
