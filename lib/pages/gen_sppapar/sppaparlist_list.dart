import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparlist_bloc.dart';
import 'package:joss_app/blocs/gen_sppapar/sppaparcrud_bloc.dart';
import 'package:joss_app/pages/gen_sppapar/sppaparcrud_form.dart';
import 'package:joss_app/pages/gen_sppapar/sppaparlist_list_widget.dart';

class SppaparListPage extends StatefulWidget {
	const SppaparListPage({super.key});

	@override
	SppaparListPageState createState() => SppaparListPageState();
}

class SppaparListPageState extends State<SppaparListPage> {
	late SppaparListBloc sppaparListBloc;
	late SppaparCrudBloc sppaparCrudBloc;
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
		sppaparListBloc = BlocProvider.of<SppaparListBloc>(context);
		sppaparCrudBloc = BlocProvider.of<SppaparCrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<SppaparListBloc, SppaparListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<SppaparCrudBloc, SppaparCrudState>(
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
		sppaparListBloc.add(
			RefreshSppaparListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		sppaparListBloc.add(TambahSppaparListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppaparListBloc.add(RefreshSppaparListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[SppaparListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return SppaparCrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			sppaparListBloc.add(CloseDialogSppaparListEvent());
		});
	}

}
