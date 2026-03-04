import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/asetothers/asetotherscari_bloc.dart';
import 'package:joss_app/pages/asetothers/asetotherscari_list_widget.dart';

class AsetothersCariPage extends StatefulWidget {
  final String cobId;
  final String statusId;
	const AsetothersCariPage({super.key, required this.cobId, required this.statusId});

	@override
	AsetothersCariPageState createState() => AsetothersCariPageState();
}

class AsetothersCariPageState extends State<AsetothersCariPage> {
	late AsetothersCariBloc asetothersCariBloc;
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
		asetothersCariBloc = BlocProvider.of<AsetothersCariBloc>(context);
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
		asetothersCariBloc.add(
			RefreshAsetothersCariEvent(cobId: widget.cobId, statusId: widget.statusId, searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asetothersCariBloc.add(RefreshAsetothersCariEvent(
        cobId: widget.cobId, statusId: widget.statusId,
				searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsetothersCariListWidget(searchText: _searchController.text)],
		));
	}

}
