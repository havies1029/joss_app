import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_endors/endors1list_bloc.dart';
import 'package:joss_app/blocs/gen_endors/endors1crud_bloc.dart';
import 'package:joss_app/pages/gen_endors/endors1list_tile_widget.dart';

class Endors1ListListWidget extends StatefulWidget {
	final String searchText;
	const Endors1ListListWidget({super.key, required this.searchText});

	@override
	Endors1ListListWidgetState createState() => Endors1ListListWidgetState();
}

class Endors1ListListWidgetState extends State<Endors1ListListWidget> {
	late Endors1ListBloc endors1ListBloc;
	late Endors1CrudBloc endors1CrudBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		endors1ListBloc = BlocProvider.of<Endors1ListBloc>(context);
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);

		return BlocConsumer<Endors1ListBloc, Endors1ListState>(
			buildWhen: (previous, current) {
				// debug perubahan status
				if (previous.status != current.status) {
					debugPrint(
							"🔄 [Endors1ListListWidget] State berubah dari ${previous.status} → ${current.status}");
				}
				return current.status == ListStatus.success;
			},
			listener: (context, state) {
				// debug log tambahan saat listener jalan
				debugPrint(
						"👂 [BlocListener] Status: ${state.status} | Items: ${state.items.length}");
			},
			builder: (context, state) {
				if (state.status == ListStatus.success) {
					debugPrint(
							"✅ [Build] ${state.items.length} data ditemukan untuk searchText='${widget.searchText}'");

					if (state.items.isNotEmpty) {
						for (final i in state.items) {
							debugPrint(
									"➡️ Endors1Id: ${i.endors1Id}, Nama: ${i.insuredNama}, Status: ${i.statusEndors}");
						}

						return Flexible(
							child: ListView.builder(
								padding: EdgeInsets.zero,
								controller: _scrollController,
								itemCount: state.items.length,
								itemBuilder: (_, index) => Container(
									margin:
									const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
									padding: const EdgeInsets.all(0.2),
									decoration: BoxDecoration(
										borderRadius: BorderRadius.circular(15.0),
									),
									child: Column(
										children: <Widget>[
											Slidable(
												endActionPane: ActionPane(
													motion: const BehindMotion(),
													children: [
														SlidableAction(
															onPressed: (context) {
																debugPrint(
																		"✏️ [Edit] Klik edit untuk ID ${state.items[index].endors1Id}");
																endors1ListBloc.add(
																	UbahEndors1ListEvent(
																		recordId:
																		state.items[index].endors1Id,
																	),
																);
															},
															backgroundColor: Colors.green,
															icon: Icons.edit,
															label: "Edit",
														),
														SlidableAction(
															onPressed: (context) {
																debugPrint(
																		"🗑️ [Delete] Klik delete untuk ID ${state.items[index].endors1Id}");
																showDialogHapus(
																		state.items[index].endors1Id);
															},
															backgroundColor: Colors.red,
															icon: Icons.delete,
															label: "Delete",
														),
													],
												),
												child: Endors1ListTileWidget(
													endorsTgl: state.items[index].endorsTgl,
													endors1Id: state.items[index].endors1Id,
													insuredNama: state.items[index].insuredNama,
													mstsendorsId: state.items[index].mstsendorsId,
													noteKonfirmasi: state.items[index].noteKonfirmasi,
													notePerubahan: state.items[index].notePerubahan,
													periodeAkhir: state.items[index].periodeAkhir,
													periodeMulai: state.items[index].periodeMulai,
													premi: state.items[index].premi,
													sppa1Id: state.items[index].sppa1Id,
													statusEndors: state.items[index].statusEndors,
													tsi: state.items[index].tsi,
												),
											),
										],
									),
								),
							),
						);
					} else {
						debugPrint("⚠️ [Empty] Tidak ada data ditemukan.");
						return const Center(
							child: Padding(
								padding: EdgeInsets.only(top: 80.0),
								child: Text(
									'No Data Available!!',
									style: TextStyle(
											color: Colors.red,
											fontSize: 12.0,
											fontWeight: FontWeight.bold),
								),
							),
						);
					}
				} else {
					debugPrint("⌛ [Loading] Status belum success → ${state.status}");
					return const Center(
						child: CircularProgressIndicator(),
					);
				}
			},
		);
	}

	void _onScroll() {
		if (!_scrollController.hasClients) return;

		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			debugPrint("📜 [Scroll] Mencapai batas bawah, ambil halaman berikutnya…");
			endors1ListBloc.add(FetchEndors1ListEvent());
		}
	}

	void onHapusFunction(String recordId) {
		debugPrint("🧹 [Hapus] Menghapus recordId: $recordId");
		endors1CrudBloc.add(Endors1CrudHapusEvent(recordId: recordId));
	}

	void showDialogHapus(String recordId) {
		debugPrint("⚠️ [DialogHapus] Buka dialog konfirmasi hapus untuk ID $recordId");
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return ShowDialogHapusWidget(
					onHapusFunction: onHapusFunction,
					recordId: recordId,
				);
			},
		).then((value) {
			debugPrint("🔙 [DialogHapus] Dialog ditutup, refresh list.");
			endors1ListBloc.add(CloseDialogEndors1ListEvent());
		});
	}
}
