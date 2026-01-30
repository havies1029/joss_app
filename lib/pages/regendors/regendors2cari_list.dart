import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/regendors/regendors2cari_bloc.dart';
import 'package:joss_app/pages/regendors/regendors2cari_list_widget.dart';

class Regendors2CariPage extends StatefulWidget {
  final String regendors1Id;
	const Regendors2CariPage({super.key, required this.regendors1Id});

	@override
	Regendors2CariPageState createState() => Regendors2CariPageState();
}

class Regendors2CariPageState extends State<Regendors2CariPage> {
	late Regendors2CariBloc regendors2CariBloc;
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
		regendors2CariBloc = BlocProvider.of<Regendors2CariBloc>(context);
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
		regendors2CariBloc.add(
			RefreshRegendors2CariEvent(regendors1Id: widget.regendors1Id));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regendors2CariBloc.add(RefreshRegendors2CariEvent(
				regendors1Id: widget.regendors1Id));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Regendors2CariListWidget()],
		));
	}

}
