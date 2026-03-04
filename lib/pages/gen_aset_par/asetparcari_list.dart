import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_par/asetparcari_list_widget.dart';

class AsetParCariPage extends StatefulWidget {
	const AsetParCariPage({super.key});

	@override
	AsetParCariPageState createState() => AsetParCariPageState();
}

class AsetParCariPageState extends State<AsetParCariPage> {
	late AsetParCariBloc asetParCariBloc;
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
		asetParCariBloc = BlocProvider.of<AsetParCariBloc>(context);
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
		asetParCariBloc.add(
			RefreshAsetParCariEvent( statusId: '10001', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asetParCariBloc.add(RefreshAsetParCariEvent(
				statusId: '10001', searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsetParCariListWidget(searchText: _searchController.text)],
		));
	}

}
