import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_endors/endors1list_bloc.dart';
import 'package:joss_app/blocs/gen_endors/endors1crud_bloc.dart';
import 'package:joss_app/pages/gen_endors/endors1crud_form.dart';
import 'package:joss_app/pages/gen_endors/endors1list_list_widget.dart';

class Endors1ListPage extends StatefulWidget {
	const Endors1ListPage({super.key});

	@override
	Endors1ListPageState createState() => Endors1ListPageState();
}

class Endors1ListPageState extends State<Endors1ListPage> {
	late Endors1ListBloc endors1ListBloc;
	late Endors1CrudBloc endors1CrudBloc;
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
		endors1ListBloc = BlocProvider.of<Endors1ListBloc>(context);
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Endors1ListBloc, Endors1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Endors1CrudBloc, Endors1CrudState>(
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
		endors1ListBloc.add(
			RefreshEndors1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		endors1ListBloc.add(TambahEndors1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			endors1ListBloc.add(RefreshEndors1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Endors1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Endors1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			endors1ListBloc.add(CloseDialogEndors1ListEvent());
		});
	}

}
