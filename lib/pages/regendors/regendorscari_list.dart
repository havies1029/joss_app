import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/regendors/regendorscari_bloc.dart';
import 'package:joss_app/pages/regendors/regendorscari_list_widget.dart';

class RegendorsCariPage extends StatefulWidget {
	const RegendorsCariPage({super.key});

	@override
	RegendorsCariPageState createState() => RegendorsCariPageState();
}

class RegendorsCariPageState extends State<RegendorsCariPage> {
	late RegendorsCariBloc regendorsCariBloc;
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
		regendorsCariBloc = BlocProvider.of<RegendorsCariBloc>(context);
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
		regendorsCariBloc.add(
			RefreshRegendorsCariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regendorsCariBloc.add(RefreshRegendorsCariEvent(
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[RegendorsCariListWidget(searchText: _searchController.text)],
		));
	}

}
