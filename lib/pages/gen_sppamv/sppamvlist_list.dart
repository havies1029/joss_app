import 'dart:convert';
import 'dart:io';

import 'package:joss_app/blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/widgets/floatingmenumaster_widget.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvlist_bloc.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvcrud_form.dart';
import 'package:joss_app/pages/gen_sppamv/sppamvlist_list_widget.dart';
import 'package:open_filex/open_filex.dart';


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
        BlocListener<SppaDownloadPolisBloc, SppaDownloadPolisState>(
          listener: (context, state)  {
            if (state is DownloadSuccess) {

              OpenFilex.open(state.filePath);

            } else if (state is DownloadFailure) {
              final message = state.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $message')),
              );
            }
          },
          listenWhen: (previous, current) {
            return current is DownloadSuccess && current.cob == 'MV';
          }
          
        ),
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

  Future<void> debugPdfFile(String path) async {
    final file = File(path);

    final exists = await file.exists();
    final len = exists ? await file.length() : 0;

    debugPrint("PDF exists: $exists");
    debugPrint("File length: $len");

    if (!exists || len < 5) {
      debugPrint("File kosong / tidak valid");
      return;
    }

    // ambil 5 byte pertama
    final headerBytes = await file.openRead(0, 5).first;
    debugPrint("First bytes: $headerBytes");

    // cek apakah %PDF-
    final isPdf = headerBytes.length == 5 &&
        headerBytes[0] == 37 &&
        headerBytes[1] == 80 &&
        headerBytes[2] == 68 &&
        headerBytes[3] == 70 &&
        headerBytes[4] == 45;

    debugPrint("Is real PDF header (%PDF-)? $isPdf");
  }

  Future<void> debugPdfTail(String path) async {
    final bytes = await File(path).readAsBytes();
    final start = (bytes.length - 300) < 0 ? 0 : (bytes.length - 300);
    final tail = String.fromCharCodes(bytes.sublist(start));
    debugPrint("=== PDF TAIL (last 300 chars) ===");
    debugPrint(tail);
    debugPrint("Contains startxref? ${tail.contains('startxref')}");
    debugPrint("Contains %%EOF? ${tail.contains('%%EOF')}");
  }

Future<void> debugPdfIntegrity(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();

  debugPrint("PDF bytes length = ${bytes.length}");

  // ambil tail 600 bytes biar aman
  final start = (bytes.length - 600) < 0 ? 0 : (bytes.length - 600);
  final tailBytes = bytes.sublist(start);
  final tail = latin1.decode(tailBytes, allowInvalid: true);

  debugPrint("=== PDF TAIL (last 600 bytes) ===");
  debugPrint(tail);

  final hasStartXref = tail.contains("startxref");
  final hasEOF = tail.contains("%%EOF");

  debugPrint("Contains startxref? $hasStartXref");
  debugPrint("Contains %%EOF? $hasEOF");

  // ambil angka startxref kalau ada
  final match = RegExp(r"startxref\s+(\d+)", multiLine: true).firstMatch(tail);
  if (match != null) {
    final xrefOffset = int.parse(match.group(1)!);
    debugPrint("startxref offset = $xrefOffset");
    debugPrint("Offset valid? ${xrefOffset < bytes.length}");
  } else {
    debugPrint("startxref number NOT found");
  }
}


}
