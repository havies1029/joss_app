import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';

class AsetRingkasanCariPage extends StatefulWidget {
	const AsetRingkasanCariPage({super.key});

	@override
	AsetRingkasanCariPageState createState() => AsetRingkasanCariPageState();
}

class AsetRingkasanCariPageState extends State<AsetRingkasanCariPage> {
	late AsetRingkasanCariBloc asetRingkasanCariBloc;  
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
		asetRingkasanCariBloc = BlocProvider.of<AsetRingkasanCariBloc>(context);
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
		asetRingkasanCariBloc.add(
			RefreshAsetRingkasanCariEvent( statusId: '10001', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			asetRingkasanCariBloc.add(RefreshAsetRingkasanCariEvent(
				statusId: '10001', searchText: _searchController.text));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[AsetRingkasanCariListWidget(searchText: _searchController.text)],
		));
	}

}
