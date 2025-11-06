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
		debugPrint("🚀 [Init] Endors1ListPage dimulai...");

		Future.delayed(const Duration(milliseconds: 500), () {
			if (!mounted) return;
			debugPrint("⏱️ [Init] Delay selesai, refresh data pertama kali...");
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		endors1ListBloc = BlocProvider.of<Endors1ListBloc>(context);
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);

		return MultiBlocListener(
			listeners: [
				// 🔹 Listener untuk perubahan ViewMode (tambah/ubah)
				BlocListener<Endors1ListBloc, Endors1ListState>(
					listenWhen: (previous, current) =>
					previous.viewMode != current.viewMode,
					listener: (context, state) {
						debugPrint("👂 [BlocListener] ViewMode berubah ke: ${state.viewMode}");
						if (state.viewMode == "tambah") {
							debugPrint("➕ [ViewMode] Buka form tambah data...");
							showDialogViewData(context, state.viewMode, "");
						} else if (state.viewMode == "ubah") {
							debugPrint("✏️ [ViewMode] Buka form ubah untuk ID: ${state.recordId}");
							showDialogViewData(context, state.viewMode, state.recordId);
						}
					},
				),

				// 🔹 Listener untuk event simpan sukses di CRUD
				BlocListener<Endors1CrudBloc, Endors1CrudState>(
					listenWhen: (previous, current) =>
					previous.isSaved != current.isSaved,
					listener: (context, state) {
						if (state.isSaved) {
							debugPrint("💾 [CRUD] Data berhasil disimpan, refresh list...");
							refreshData();
						}
					},
				),
			],
			child: Scaffold(
				floatingActionButton: FloatingMenuMasterWidget(
					onTambah: onTambahData,
				),
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						children: [
							ListPageFilterBarUIWidget(
								searchController: _searchController,
								searchButton: buildSearchButton(),
							),
							buildList(),
						],
					),
				),
			),
		);
	}

	// 🔹 Fungsi untuk refresh data list
	void refreshData() {
		debugPrint(
				"🔄 [RefreshData] Kirim event RefreshEndors1ListEvent(searchText='${_searchController.text}', hal=0)");
		endors1ListBloc.add(
			RefreshEndors1ListEvent(searchText: _searchController.text, hal: 0),
		);
	}

	// 🔹 Fungsi ketika tombol tambah ditekan
	void onTambahData() {
		debugPrint("➕ [onTambahData] Tombol tambah ditekan");
		endors1ListBloc.add(TambahEndors1ListEvent());
	}

	// 🔹 Tombol Search
	IconButton buildSearchButton() {
		return IconButton(
			icon: const Icon(Icons.autorenew_rounded, size: 35.0),
			onPressed: () {
				debugPrint(
						"🔍 [SearchButton] Ditekan, cari dengan keyword='${_searchController.text}'");
				endors1ListBloc.add(
					RefreshEndors1ListEvent(
						searchText: _searchController.text,
						hal: 0,
					),
				);
			},
		);
	}

	// 🔹 Widget List utama
	Widget buildList() {
		debugPrint("🧱 [BuildList] Bangun widget list dengan filter='${_searchController.text}'");
		return Expanded(
			child: Endors1ListListWidget(
				searchText: _searchController.text,
			),
		);
	}

	// 🔹 Dialog Tambah/Ubah data
	void showDialogViewData(
			BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		debugPrint("🪟 [Dialog] Buka dialog ($viewMode) untuk recordId='$recordId'");

		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Endors1CrudFormPage(
					viewMode: viewMode,
					recordId: recordId,
				);
			},
			useSafeArea: true,
		).then((value) {
			debugPrint("🔙 [Dialog] Dialog ditutup, kirim event CloseDialogEndors1ListEvent()");
			endors1ListBloc.add(CloseDialogEndors1ListEvent());
		});
	}
}
