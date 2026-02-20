import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvstatuscari_bloc.dart';

import 'klaimmvstatuscari_list_widget.dart';
// import 'package:joss_app/pages/perbaruiklaimmv/klaimmvstatuscari_list_widget.dart';

class KlaimmvstatuscariPage extends StatefulWidget {
  final String klaim1Id;
	const KlaimmvstatuscariPage({super.key, required this.klaim1Id});

	@override
	KlaimmvstatuscariPageState createState() => KlaimmvstatuscariPageState();
}

class KlaimmvstatuscariPageState extends State<KlaimmvstatuscariPage> {
	late KlaimmvstatuscariBloc klaimmvstatuscariBloc;
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
		klaimmvstatuscariBloc = BlocProvider.of<KlaimmvstatuscariBloc>(context);
		return Column(
		  children: [
		    buildList(),
		  ],
		);
	}
	void refreshData() {
		klaimmvstatuscariBloc.add(
			RefreshKlaimmvstatuscariEvent(klaim1Id: widget.klaim1Id),);
	}

	Widget buildList() {
		return KlaimmvstatuscariListWidget(searchText: _searchController.text);
	}

}
