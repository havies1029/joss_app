import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
import 'package:joss_app/pages/gen_klaim/klaim1crud_form.dart';
import 'package:joss_app/pages/gen_klaim/klaim1list_list_widget.dart';

class Klaim1ListPage extends StatefulWidget {
	const Klaim1ListPage({super.key});

	@override
	Klaim1ListPageState createState() => Klaim1ListPageState();
}

class Klaim1ListPageState extends State<Klaim1ListPage> {
	late Klaim1ListBloc klaim1ListBloc;
	late Klaim1CrudBloc klaim1CrudBloc;
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
		klaim1CrudBloc = BlocProvider.of<Klaim1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Klaim1ListBloc, Klaim1ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Klaim1CrudBloc, Klaim1CrudState>(
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

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Klaim1CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			klaim1ListBloc.add(CloseDialogKlaim1ListEvent());
		});
	}

}
