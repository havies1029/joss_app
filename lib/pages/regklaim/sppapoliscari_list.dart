import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/regklaim/sppapoliscari_bloc.dart';
import 'package:joss_app/pages/regklaim/sppapoliscari_list_widget.dart';

class SppapoliscariPage extends StatefulWidget {
  final String cobKlaimId;  
  final String cobKlaimNama;
	const SppapoliscariPage({super.key, required this.cobKlaimId, required this.cobKlaimNama});

	@override
	SppapoliscariPageState createState() => SppapoliscariPageState();
}

class SppapoliscariPageState extends State<SppapoliscariPage> {
	late SppapoliscariBloc sppapoliscariBloc;
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
		sppapoliscariBloc = BlocProvider.of<SppapoliscariBloc>(context);
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
		sppapoliscariBloc.add(
			RefreshSppapoliscariEvent(
        cobKlaimId: widget.cobKlaimId,
        searchText: _searchController.text
        ));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppapoliscariBloc.add(RefreshSppapoliscariEvent(
        cobKlaimId: widget.cobKlaimId,
        searchText: _searchController.text
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[SppapoliscariListWidget()],
		));
	}

}
