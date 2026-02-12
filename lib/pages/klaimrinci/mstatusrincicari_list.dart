import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/pages/klaimrinci/mstatusrincicari_list_widget.dart';

class MstatusrinciCariPage extends StatefulWidget {
	const MstatusrinciCariPage({super.key});

	@override
	MstatusrinciCariPageState createState() => MstatusrinciCariPageState();
}

class MstatusrinciCariPageState extends State<MstatusrinciCariPage> {
	late MstatusrinciCariBloc mstatusrinciCariBloc;
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
		mstatusrinciCariBloc = BlocProvider.of<MstatusrinciCariBloc>(context);
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
		mstatusrinciCariBloc.add(
			RefreshMstatusrinciCariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			mstatusrinciCariBloc.add(RefreshMstatusrinciCariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[MstatusrinciCariListWidget(searchText: _searchController.text)],
		));
	}

}
