import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regklaim/cobklaimcari_bloc.dart';
import 'package:joss_app/pages/regklaim/cobklaimcari_list_widget.dart';

class CobklaimcariPage extends StatefulWidget {
	const CobklaimcariPage({super.key});

	@override
	CobklaimcariPageState createState() => CobklaimcariPageState();
}

class CobklaimcariPageState extends State<CobklaimcariPage> {
	late CobklaimcariBloc cobklaimcariBloc;
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
		cobklaimcariBloc = BlocProvider.of<CobklaimcariBloc>(context);
		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [					
					buildList()
				],

			),
		);
	}
	void refreshData() {
		cobklaimcariBloc.add(
			RefreshCobklaimcariEvent());
	}
	

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[CobklaimcariListWidget(searchText: _searchController.text)],
		));
	}

}
