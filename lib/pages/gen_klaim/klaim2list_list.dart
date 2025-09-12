import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_klaim/klaim2list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim2crud_bloc.dart';
import 'package:joss_app/pages/gen_klaim/klaim2crud_form.dart';
import 'package:joss_app/pages/gen_klaim/klaim2list_list_widget.dart';

class Klaim2ListPage extends StatefulWidget {
	const Klaim2ListPage({super.key});

	@override
	Klaim2ListPageState createState() => Klaim2ListPageState();
}

class Klaim2ListPageState extends State<Klaim2ListPage> {
	late Klaim2ListBloc klaim2ListBloc;
	late Klaim2CrudBloc klaim2CrudBloc;
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
		klaim2ListBloc = BlocProvider.of<Klaim2ListBloc>(context);
		klaim2CrudBloc = BlocProvider.of<Klaim2CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<Klaim2ListBloc, Klaim2ListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<Klaim2CrudBloc, Klaim2CrudState>(
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
		klaim2ListBloc.add(
			RefreshKlaim2ListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		klaim2ListBloc.add(TambahKlaim2ListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			klaim2ListBloc.add(RefreshKlaim2ListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[Klaim2ListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Klaim2CrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			klaim2ListBloc.add(CloseDialogKlaim2ListEvent());
		});
	}

}
