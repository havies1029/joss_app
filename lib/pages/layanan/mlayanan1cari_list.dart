import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/layanan/mlayanan1cari_bloc.dart';
import 'package:joss_app/pages/layanan/mlayanan1cari_list_widget.dart';

class Mlayanan1CariPage extends StatefulWidget {
	const Mlayanan1CariPage({super.key});

	@override
	Mlayanan1CariPageState createState() => Mlayanan1CariPageState();
}

class Mlayanan1CariPageState extends State<Mlayanan1CariPage> {
	late Mlayanan1CariBloc mlayanan1CariBloc;
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
		mlayanan1CariBloc = BlocProvider.of<Mlayanan1CariBloc>(context);
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
		mlayanan1CariBloc.add(
			RefreshMlayanan1CariEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			mlayanan1CariBloc.add(RefreshMlayanan1CariEvent(
				));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Mlayanan1CariListWidget()],
		));
	}

}
