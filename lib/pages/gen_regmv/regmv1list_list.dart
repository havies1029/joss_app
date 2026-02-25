import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1list_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1crud_bloc.dart';
import 'package:joss_app/pages/gen_regmv/regmv1crud_form.dart';

class Regmv1ListPage extends StatefulWidget {
	const Regmv1ListPage({super.key});

	@override
	Regmv1ListPageState createState() => Regmv1ListPageState();
}

class Regmv1ListPageState extends State<Regmv1ListPage> {
	late Regmv1ListBloc regmv1ListBloc;
	late Regmv1CrudBloc regmv1CrudBloc;
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
		regmv1ListBloc = BlocProvider.of<Regmv1ListBloc>(context);
		regmv1CrudBloc = BlocProvider.of<Regmv1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Regmv1ListBloc, Regmv1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Regmv1CrudBloc, Regmv1CrudState>(
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
							// buildList()
						],

					),
				),
			));
	}

	void refreshData() {
		regmv1ListBloc.add(
			RefreshRegmv1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		regmv1ListBloc.add(TambahRegmv1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			regmv1ListBloc.add(RefreshRegmv1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	// Widget buildList() {
	// 	return Expanded(
	// 		child: Column(
	// 			mainAxisAlignment: MainAxisAlignment.start,
	// 			children: <Widget>[Regmv1ListListWidget(searchText: _searchController.text)],
	// 	));
	// }

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Regmv1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			regmv1ListBloc.add(CloseDialogRegmv1ListEvent());
		});
	}

}
