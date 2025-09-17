import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_mv/asetmvcari_list_widget.dart';

class AsetMvCariPage extends StatefulWidget {
	const AsetMvCariPage({super.key});

	@override
	AsetMvCariPageState createState() => AsetMvCariPageState();
}

class AsetMvCariPageState extends State<AsetMvCariPage> {
	late AsetMvCariBloc asetMvCariBloc;
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
		asetMvCariBloc = BlocProvider.of<AsetMvCariBloc>(context);
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
		asetMvCariBloc.add(
			RefreshAsetMvCariEvent(statusId: '10001', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asetMvCariBloc.add(RefreshAsetMvCariEvent(statusId: '10001',
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsetMvCariListWidget(searchText: _searchController.text)],
		));
	}

}
