import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/logoclient/mlogoclientcari_bloc.dart';
import 'package:joss_app/pages/logoclient/mlogoclientcari_list_widget.dart';

class MlogoclientCariPage extends StatefulWidget {
	const MlogoclientCariPage({super.key});

	@override
	MlogoclientCariPageState createState() => MlogoclientCariPageState();
}

class MlogoclientCariPageState extends State<MlogoclientCariPage> {
	late MlogoclientCariBloc mlogoclientCariBloc;
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
		mlogoclientCariBloc = BlocProvider.of<MlogoclientCariBloc>(context);
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
		mlogoclientCariBloc.add(
			RefreshMlogoclientCariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			mlogoclientCariBloc.add(RefreshMlogoclientCariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[MlogoclientCariListWidget(searchText: _searchController.text)],
		));
	}

}
