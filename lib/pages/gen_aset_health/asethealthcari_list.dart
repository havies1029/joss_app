import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_health/asethealthcari_list_widget.dart';

class AsetHealthCariPage extends StatefulWidget {
	const AsetHealthCariPage({super.key});

	@override
	AsetHealthCariPageState createState() => AsetHealthCariPageState();
}

class AsetHealthCariPageState extends State<AsetHealthCariPage> {
	late AsetHealthCariBloc asetHealthCariBloc;
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
		asetHealthCariBloc = BlocProvider.of<AsetHealthCariBloc>(context);
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
		asetHealthCariBloc.add(
			RefreshAsetHealthCariEvent(searchText: _searchController.text, statusId: '10001'));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asetHealthCariBloc.add(RefreshAsetHealthCariEvent(
				searchText: _searchController.text, statusId: '10001'));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsetHealthCariListWidget(searchText: _searchController.text)],
		));
	}

}
