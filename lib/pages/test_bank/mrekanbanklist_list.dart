import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/gen_profile/mrekanbankcrud_bloc.dart';
import '../../blocs/gen_profile/mrekanbanklist_bloc.dart';
import '../../widgets/floatingmenumaster_widget.dart';
import '../../widgets/listpage_filter_bar_ui.dart';
import 'mrekanbanklist_list_widget.dart';
import 'mrekanbankcrud_form.dart';


class MRekanBankListPage extends StatefulWidget {
	const MRekanBankListPage({super.key});

	@override
	MRekanBankListPageState createState() => MRekanBankListPageState();
}

class MRekanBankListPageState extends State<MRekanBankListPage> {
	late MRekanBankListBloc mRekanBankListBloc;
	late MRekanBankCrudBloc mRekanBankCrudBloc;
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
		mRekanBankListBloc = BlocProvider.of<MRekanBankListBloc>(context);
		mRekanBankCrudBloc = BlocProvider.of<MRekanBankCrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				BlocListener<MRekanBankListBloc, MRekanBankListState>(
					listener: (context, state) {
						if (state.viewMode == "tambah") {
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							showDialogViewData(context, state.viewMode, state.recordId);
						}
				}, listenWhen: (previous, current) {
					return previous.viewMode != current.viewMode;
				}),
				BlocListener<MRekanBankCrudBloc, MRekanBankCrudState>(
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
		mRekanBankListBloc.add(
			RefreshMRekanBankListEvent(searchText: _searchController.text, hal: 0));
	}

	void onTambahData() {
		mRekanBankListBloc.add(TambahMRekanBankListEvent());
	}

	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(
				Icons.autorenew_rounded,
				size: 35.0,
			),
			onPressed: () {
			mRekanBankListBloc.add(RefreshMRekanBankListEvent(
				searchText: _searchController.text, hal: 0));
			});
	}

	Widget buildList() {
		return Expanded(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: <Widget>[MRekanBankListListWidget(searchText: _searchController.text)],
		));
	}

	void showDialogViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return MRekanBankCrudFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true)
		.then((value) {
			mRekanBankListBloc.add(CloseDialogMRekanBankListEvent());
		});
	}

}
