import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1list_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/pages/gen_calmv/calmv1crud_form.dart';
import 'package:joss_app/pages/gen_calmv/calmv1list_list_widget.dart';

class Calmv1ListPage extends StatefulWidget {
	const Calmv1ListPage({super.key});

	@override
	Calmv1ListPageState createState() => Calmv1ListPageState();
}

class Calmv1ListPageState extends State<Calmv1ListPage> {
	late Calmv1ListBloc calmv1ListBloc;
	late Calmv1CrudBloc calmv1CrudBloc;
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
		calmv1ListBloc = BlocProvider.of<Calmv1ListBloc>(context);
		calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Calmv1ListBloc, Calmv1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
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
		calmv1ListBloc.add(
			RefreshCalmv1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		calmv1ListBloc.add(TambahCalmv1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			calmv1ListBloc.add(RefreshCalmv1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Calmv1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Calmv1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			calmv1ListBloc.add(CloseDialogCalmv1ListEvent());
		});
	}

}
