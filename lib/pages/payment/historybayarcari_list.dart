import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/payment/historybayarcari_list_widget.dart';

class HistorybayarCariPage extends StatefulWidget {
	const HistorybayarCariPage({super.key});

	@override
	HistorybayarCariPageState createState() => HistorybayarCariPageState();
}

class HistorybayarCariPageState extends State<HistorybayarCariPage> {
	late HistorybayarCariBloc historybayarCariBloc;
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
		historybayarCariBloc = BlocProvider.of<HistorybayarCariBloc>(context);
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
		historybayarCariBloc.add(
			RefreshHistorybayarCariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			historybayarCariBloc.add(RefreshHistorybayarCariEvent(statusId: '',
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[HistorybayarCariListWidget(searchText: _searchController.text)],
		));
	}

}
