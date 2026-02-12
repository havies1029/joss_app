import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/klaimrasio/klaimrasiocobcari_bloc.dart';
import 'package:joss_app/pages/klaimrasio/klaimrasiocobcari_list_widget.dart';

class KlaimrasiocobCariPage extends StatefulWidget {
	const KlaimrasiocobCariPage({super.key});

	@override
	KlaimrasiocobCariPageState createState() => KlaimrasiocobCariPageState();
}

class KlaimrasiocobCariPageState extends State<KlaimrasiocobCariPage> {
	late KlaimrasiocobCariBloc klaimrasiocobCariBloc;
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
		klaimrasiocobCariBloc = BlocProvider.of<KlaimrasiocobCariBloc>(context);
		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					ListPageFilterBarUIWidget(
						searchController: _searchController,
						searchButton: buildSearchButton()),
					Expanded(child: KlaimrasiocobCariListWidget())
				],

			),
		);
	}
	void refreshData() {
		klaimrasiocobCariBloc.add(
			RefreshKlaimrasiocobCariEvent(searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			klaimrasiocobCariBloc.add(RefreshKlaimrasiocobCariEvent(
				searchText: _searchController.text));
			});
	}

}
