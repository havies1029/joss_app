import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/pages/gen_status_aset/statusasetcari_list_widget.dart';

class StatusAsetCariPage extends StatefulWidget {
	const StatusAsetCariPage({super.key});

	@override
	StatusAsetCariPageState createState() => StatusAsetCariPageState();
}

class StatusAsetCariPageState extends State<StatusAsetCariPage> {
	late StatusAsetCariBloc statusAsetCariBloc;
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
		statusAsetCariBloc = BlocProvider.of<StatusAsetCariBloc>(context);
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
		statusAsetCariBloc.add(
			RefreshStatusAsetCariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			statusAsetCariBloc.add(RefreshStatusAsetCariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[StatusAsetCariListWidget(searchText: _searchController.text)],
		));
	}

}
