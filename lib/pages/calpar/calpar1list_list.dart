import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/calpar/calpar1list_bloc.dart';
import 'package:joss_app/blocs/calpar/calpar1crud_bloc.dart';
import 'package:joss_app/pages/calpar/calpar1crud_form.dart';
import 'package:joss_app/pages/calpar/calpar1list_list_widget.dart';

class Calpar1ListPage extends StatefulWidget {
	const Calpar1ListPage({super.key});

	@override
	Calpar1ListPageState createState() => Calpar1ListPageState();
}

class Calpar1ListPageState extends State<Calpar1ListPage> {
	late Calpar1ListBloc calpar1ListBloc;
	late Calpar1CrudBloc calpar1CrudBloc;
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
		calpar1ListBloc = BlocProvider.of<Calpar1ListBloc>(context);
		calpar1CrudBloc = BlocProvider.of<Calpar1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Calpar1ListBloc, Calpar1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Calpar1CrudBloc, Calpar1CrudState>(
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
		calpar1ListBloc.add(
			RefreshCalpar1ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		calpar1ListBloc.add(TambahCalpar1ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			calpar1ListBloc.add(RefreshCalpar1ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Calpar1ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Calpar1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			calpar1ListBloc.add(CloseDialogCalpar1ListEvent());
		});
	}

}
