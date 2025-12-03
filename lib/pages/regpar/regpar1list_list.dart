import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/regpar/regpar1list_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar1crud_bloc.dart';
import 'package:joss_app/pages/regpar/regpar1crud_form.dart';
import 'package:joss_app/pages/regpar/regpar1list_list_widget.dart';

class Regpar1ListPage extends StatefulWidget {
	const Regpar1ListPage({super.key});

	@override
	Regpar1ListPageState createState() => Regpar1ListPageState();
}

class Regpar1ListPageState extends State<Regpar1ListPage> {
	late Regpar1ListBloc regpar1ListBloc;
	late Regpar1CrudBloc regpar1CrudBloc;
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
		regpar1ListBloc = BlocProvider.of<Regpar1ListBloc>(context);
		regpar1CrudBloc = BlocProvider.of<Regpar1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Regpar1ListBloc, Regpar1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
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
		regpar1ListBloc.add(
			RefreshRegpar1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		regpar1ListBloc.add(TambahRegpar1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regpar1ListBloc.add(RefreshRegpar1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Regpar1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Regpar1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			regpar1ListBloc.add(CloseDialogRegpar1ListEvent());
		});
	}

}
