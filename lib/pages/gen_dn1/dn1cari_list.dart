import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_dn1/dn1cari_bloc.dart';
import 'package:joss_app/pages/gen_dn1/dn1cari_list_widget.dart';

class Dn1CariPage extends StatefulWidget {
  final String sppa1Id;
	const Dn1CariPage({super.key, required this.sppa1Id});

	@override
	Dn1CariPageState createState() => Dn1CariPageState();
}

class Dn1CariPageState extends State<Dn1CariPage> {
	late Dn1CariBloc dn1CariBloc;
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
		dn1CariBloc = BlocProvider.of<Dn1CariBloc>(context);

		return Scaffold(
			body: Column(
				children: [
					ListPageFilterBarUIWidget(
						searchController: _searchController,
						searchButton: buildSearchButton(),
					),
					Expanded(
						child: Dn1CariListWidget(searchText: _searchController.text),
					),
				],
			),
		);
	}

	void refreshData() {
		dn1CariBloc.add(
			RefreshDn1CariEvent(sppa1Id: widget.sppa1Id));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
				dn1CariBloc.add(RefreshDn1CariEvent(sppa1Id: widget.sppa1Id));
			},
		);
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Dn1CariListWidget(searchText: _searchController.text)],
		));
	}

}
