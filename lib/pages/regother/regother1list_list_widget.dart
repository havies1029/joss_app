import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regother/regother1list_list.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/regother/regother1list_bloc.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/pages/regother/regother1crud_form.dart';

class Regother1ListPage extends StatefulWidget {
	const Regother1ListPage({super.key});

	@override
	Regother1ListPageState createState() => Regother1ListPageState();
}

class Regother1ListPageState extends State<Regother1ListPage> {
	late Regother1ListBloc regother1ListBloc;
	late Regother1CrudBloc regother1CrudBloc;
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
		regother1ListBloc = BlocProvider.of<Regother1ListBloc>(context);
		regother1CrudBloc = BlocProvider.of<Regother1CrudBloc>(context);

		return MultiBlocListener(
				listeners: [
					BlocListener<Regother1ListBloc, Regother1ListState>(
							listener: (context, state) {
								if (state.viewMode == "tambah") {
									showDialogViewData(context, state.viewMode, "");
								} else if (state.viewMode == "ubah") {
									showDialogViewData(context, state.viewMode, state.recordId);
								}
							}, listenWhen: (previous, current) {
						return previous.viewMode != current.viewMode;
					}),
					BlocListener<Regother1CrudBloc, Regother1CrudState>(
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
		regother1ListBloc.add(
				RefreshRegother1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		regother1ListBloc.add(TambahRegother1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
				icon: const Icon(
					Icons.autorenew_rounded,
					size: 35.0,
				),
				onPressed: () {
					regother1ListBloc.add(RefreshRegother1ListEvent(
							searchText: _searchController.text, hal: 0));
				});
	}

	Widget buildList() {
		return Expanded(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[Regother1ListListWidget(searchText: _searchController.text)],
				));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Regother1CrudFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true)
				.then((value) {
			regother1ListBloc.add(CloseDialogRegother1ListEvent());
		});
	}

}
