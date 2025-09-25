import 'package:joss_app/pages/simulpar/simulparcrud_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/simulpar/simulparlist_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/pages/simulpar/simulparlist_list_widget.dart';

class SimulparListPage extends StatefulWidget {
	const SimulparListPage({super.key});

	@override
	SimulparListPageState createState() => SimulparListPageState();
}

class SimulparListPageState extends State<SimulparListPage> {
	late SimulparListBloc simulparListBloc;
	late SimulparCrudBloc simulparCrudBloc;
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
		simulparListBloc = BlocProvider.of<SimulparListBloc>(context);
		simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<SimulparListBloc, SimulparListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<SimulparCrudBloc, SimulparCrudState>(
					listener: (context, state) {
						if (state.isSaved) {
							refreshData();
						}
				}, listenWhen: (previous, current) {
					return previous.isSaved != current.isSaved;
				}),
			],
			child: Scaffold(
				floatingActionButton: FloatingMenuMasterWidget(
					onTambah: onTambahData),
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: [
							// ListPageFilterBarUIWidget(
							// 	searchController: _searchController,
							// 	searchButton: buildSearchButton()),
							buildList()
						],

					),
				),
			));
	}

	void refreshData() {
		simulparListBloc.add(
			RefreshSimulparListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		simulparListBloc.add(TambahSimulparListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			simulparListBloc.add(RefreshSimulparListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[SimulparListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SimulparCrudMainPage();
    }));
	}

}
