import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvlist_bloc.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvcrud_form.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvlist_list_widget.dart';

class SppamvListPage extends StatefulWidget {
	const SppamvListPage({super.key});

	@override
	SppamvListPageState createState() => SppamvListPageState();
}

class SppamvListPageState extends State<SppamvListPage> {
	late SppamvListBloc sppamvListBloc;
	late SppamvCrudBloc sppamvCrudBloc;
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
		sppamvListBloc = BlocProvider.of<SppamvListBloc>(context);
		sppamvCrudBloc = BlocProvider.of<SppamvCrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<SppamvListBloc, SppamvListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<SppamvCrudBloc, SppamvCrudState>(
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
		sppamvListBloc.add(
			RefreshSppamvListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		sppamvListBloc.add(TambahSppamvListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			sppamvListBloc.add(RefreshSppamvListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[SppamvListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return SppamvCrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			sppamvListBloc.add(CloseDialogSppamvListEvent());
		});
	}

}
