import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/mstsgroupinvcari_bloc.dart';
import 'package:joss_app/pages/payment/mstsgroupinvcari_list_widget.dart';

class MstsgroupinvCariPage extends StatefulWidget {
	const MstsgroupinvCariPage({super.key});

	@override
	MstsgroupinvCariPageState createState() => MstsgroupinvCariPageState();
}

class MstsgroupinvCariPageState extends State<MstsgroupinvCariPage> {
	late MstsgroupinvCariBloc mstsgroupinvCariBloc;
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
		mstsgroupinvCariBloc = BlocProvider.of<MstsgroupinvCariBloc>(context);
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
		mstsgroupinvCariBloc.add(
			RefreshMstsgroupinvCariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			mstsgroupinvCariBloc.add(RefreshMstsgroupinvCariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[MstsgroupinvCariListWidget(searchText: _searchController.text)],
		));
	}

}
