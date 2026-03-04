import 'package:joss_app/pages/klaim/klaim2list_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/klaim/klaim1list_bloc.dart';
import 'package:joss_app/pages/klaim/klaim1list_list_widget.dart';

class Klaim1ListPage extends StatefulWidget {
	const Klaim1ListPage({super.key});

	@override
	Klaim1ListPageState createState() => Klaim1ListPageState();
}

class Klaim1ListPageState extends State<Klaim1ListPage> {
	late Klaim1ListBloc klaim1ListBloc;
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
		klaim1ListBloc = BlocProvider.of<Klaim1ListBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Klaim1ListBloc, Klaim1ListState>(
					listener: (context, state) {
						if (state.viewMode == "track") {
							showDialogViewData(context, state.recordId);
						} 
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),				
			],
			child: Scaffold(
				floatingActionButton: FloatingMenuMasterWidget(
					onTambah: onTambahData),
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: [
							ListPageFilterBarUIWidget(
								searchController: _searchController,
								searchButton: buildSearchButton()),
							buildList()
						],

					),
				),
			));
	}

	void refreshData() {
		klaim1ListBloc.add(
			RefreshKlaim1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		klaim1ListBloc.add(TambahKlaim1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			klaim1ListBloc.add(RefreshKlaim1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Klaim1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String klaim1Id) {
		FocusScope.of(context).requestFocus(FocusNode());

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      //return Klaim2ListTimeline(klaim1Id: klaim1Id);
      return Klaim2ListMainPage(klaim1Id: klaim1Id);
    }));
	}

}
