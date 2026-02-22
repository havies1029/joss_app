// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/widgets/list_extension.dart';
// import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';
// import 'package:joss_app/repositories/gen_aset_par/asetparcari_repository.dart';
//
// part 'asetparcari_event.dart';
// part 'asetparcari_state.dart';
//
// class AsetParCariBloc extends Bloc<AsetParCariEvents, AsetParCariState> {
// 	AsetParCariBloc() : super(const AsetParCariState()) {
// 		on<FetchAsetParCariEvent>(onFetchAsetParCari);
// 		on<RefreshAsetParCariEvent>(onRefreshAsetParCari);
// 		on<DebugFetchAsetParCariEvent>(_onDebugFetchAsetParCari);
//
// 		on<SelectDetailEvent>(onSelectDetail);
// 		on<UnselectDetailEvent>(onUnselectDetail);
// 		on<ClearParSelectionEvent>(onClearSelection);
//
// 		on<SelectPolisParDetailEvent>(onSelectPolisParDetail);
// 		on<UnselectPolisParDetailEvent>(onUnselectPolisParDetail);
// 		on<ClearPolisParSelectionEvent>(onClearPolisParSelection);
//
// 		on<SelectPolisEqDetailEvent>(onSelectPolisEqDetail);
// 		on<UnselectPolisEqDetailEvent>(onUnselectPolisEqDetail);
// 		on<ClearPolisEqSelectionEvent>(onClearPolisEqSelection);
// 	}
//
// 	Future<void> onRefreshAsetParCari(
// 			RefreshAsetParCariEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		emit(AsetParCariState(
// 			items: const [],
// 			status: ListStatus.initial,
// 			hal: 0,
// 			searchText: event.searchText,
// 			statusId: event.statusId,
// 			hasReachedMax: false,
// 		));
//
// 		emit(state.copyWith(
// 			searchText: event.searchText,
// 			hal: 0,
// 			statusId: event.statusId,
// 		));
//
// 		add(FetchAsetParCariEvent());
// 	}
//
// 	// 📦 Fetch normal (update UI)
// 	Future<void> onFetchAsetParCari(
// 			FetchAsetParCariEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		if (state.hasReachedMax) return;
//
// 		final repo = AsetParCariRepository();
//
// 		if (state.status == ListStatus.initial) {
// 			final items = await repo.getAsetParCari(state.statusId, state.searchText, 0);
// 			return emit(state.copyWith(
// 				items: items,
// 				hasReachedMax: false,
// 				status: ListStatus.success,
// 				hal: 1,
// 			));
// 		}
//
// 		final items = await repo.getAsetParCari(state.statusId, state.searchText, state.hal);
// 		if (items.isEmpty) {
// 			return emit(state.copyWith(hasReachedMax: true));
// 		} else {
// 			final asetParCari = List.of(state.items)..addAll(items);
//
// 			final result = asetParCari
// 					.whereWithIndex((e, index) =>
// 			asetParCari.indexWhere((e2) => e2.asetParId == e.asetParId) == index)
// 					.toList();
//
// 			return emit(state.copyWith(
// 				items: result,
// 				hasReachedMax: false,
// 				status: ListStatus.success,
// 				hal: state.hal + 1,
// 			));
// 		}
// 	}
//
// 	// 🧠 Debug Fetch (tidak ubah UI, hanya tampil di console)
// 	Future<void> _onDebugFetchAsetParCari(
// 			DebugFetchAsetParCariEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		final repo = AsetParCariRepository();
//
// 		debugPrint("🏠 [DebugFetch] Mulai ambil data PAR untuk '${event.searchText}'...");
//
// 		try {
// 			final results = await repo.getAsetParCari(event.statusId, event.searchText, 0);
//
// 			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
// 			for (final i in results) {
// 				debugPrint("""
// 				🏠 [Data PAR]
// 				──────────────────────────────
// 				• Alamat       : ${i.alamat}
// 				• Currency     : ${i.curr}
// 				• Polis No     : ${i.polisNo}
// 				• Sum Insured  : ${i.sumInsured}
// 				• Premi        : ${i.premi}
// 				• Status       : ${i.status}
// 				──────────────────────────────
// 				""");
// 			}
// 			debugPrint("-----------------------------------------------------");
// 		} catch (e, stack) {
// 			debugPrint("💥 [DebugFetch] Error: $e");
// 			debugPrint(stack.toString());
// 		}
// 	}
//
// 	Future<void> onSelectDetail(
// 			SelectDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..add(event.asetParId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onUnselectDetail(
// 			UnselectDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..remove(event.asetParId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onClearSelection(
// 			ClearParSelectionEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		if (state.selectedIds.isEmpty) return;
// 		emit(state.copyWith(selectedIds: <String>{}));
// 	}
//
//
//
//
//
//
//
//
//
//
//
// 	Future<void> onSelectPolisParDetail(
// 			SelectPolisParDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisParId: event.filePolisParId,
// 		));
// 	}
//
//
// 	Future<void> onUnselectPolisParDetail(
// 			UnselectPolisParDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisParId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisParSelection(
// 			ClearPolisParSelectionEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisParId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisParId: "",
// 		));
// 	}
//
//
//
//
// 	Future<void> onSelectPolisEqDetail(
// 			SelectPolisEqDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisEqId: event.filePolisEqId,
// 		));
// 	}
//
// 	Future<void> onUnselectPolisEqDetail(
// 			UnselectPolisEqDetailEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisEqId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisEqSelection(
// 			ClearPolisEqSelectionEvent event,
// 			Emitter<AsetParCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisEqId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisEqId: "",
// 		));
// 	}
// }

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';
import 'package:joss_app/repositories/gen_aset_par/asetparcari_repository.dart';

part 'asetparcari_event.dart';
part 'asetparcari_state.dart';

class AsetParCariBloc extends Bloc<AsetParCariEvents, AsetParCariState> {
	AsetParCariBloc() : super(const AsetParCariState()) {
		on<FetchAsetParCariEvent>(onFetchAsetParCari);
		on<RefreshAsetParCariEvent>(onRefreshAsetParCari);
		on<DebugFetchAsetParCariEvent>(_onDebugFetchAsetParCari);

		on<SelectDetailEvent>(onSelectDetail);
		on<UnselectDetailEvent>(onUnselectDetail);
		on<ClearParSelectionEvent>(onClearSelection);

		on<SelectPolisParDetailEvent>(onSelectPolisParDetail);
		on<UnselectPolisParDetailEvent>(onUnselectPolisParDetail);
		on<ClearPolisParSelectionEvent>(onClearPolisParSelection);

		on<SelectPolisEqDetailEvent>(onSelectPolisEqDetail);
		on<UnselectPolisEqDetailEvent>(onUnselectPolisEqDetail);
		on<ClearPolisEqSelectionEvent>(onClearPolisEqSelection);

		on<SelectSingleParDetailEvent>(onSelectDetailId);
		on<UnselectSingleParDetailEvent>(onUnselectDetailParId);
		on<SelectParCariEvent>((event, emit) {
			emit(state.copyWith(selectedItem: event.selectedItem));
		});
		on<SelectProsesParIdEvent>((event, emit) {
			emit(state.copyWith(selectedProsesId: event.prosesId));
		});
		on<ClearSelectedItemEvent>((event, emit) {
			emit(state.copyWith(selectedItem: null));
		});
	}

	String buildKey({required String search, required String statusId, String? cobId}) {
		final s = search.trim().toLowerCase();
		final c = cobId ?? '';
		return '$s|$c|$statusId';
	}

	Future<void> onRefreshAsetParCari(
			RefreshAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		final newKey = buildKey(search: event.searchText, statusId: event.statusId);

		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			searchText: event.searchText,
			statusId: event.statusId,
			queryKey: newKey,
			// items: state.items  // tetap biar ga kedip
		));

		add(FetchAsetParCariEvent());
	}

	Future<void> onFetchAsetParCari(
			FetchAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;

		final repo = AsetParCariRepository();
		final keyAtRequest = state.queryKey;

		emit(state.copyWith(isFetching: true));

		try {
			final nextHal = state.hal; // 0 untuk first page, dst.
			final items = await repo.getAsetParCari(
				state.statusId,
				state.searchText,
				nextHal,
			);

			// kalau query berubah saat nunggu -> buang hasil
			if (state.queryKey != keyAtRequest) return;

			// helper ambil 5 id pertama (biar kelihatan nyampur apa enggak)
			List<String> first5IdsFrom(List<AsetParCariModel> list) {
				return list
						.take(5)
						.map((e) => e.asetParId) // ganti kalau field id kamu beda
						.toList();
			}

			if (nextHal == 0) {
				// FIRST PAGE selalu REPLACE, bukan append
				emit(state.copyWith(
					items: items,
					hasReachedMax: items.isEmpty,
					status: ListStatus.success,
					hal: 1,
					isFetching: false,
				));

				_recomputeActiveAndFiles(emit);
				return;
			}

			if (items.isEmpty) {
				emit(state.copyWith(hasReachedMax: true, isFetching: false));
				return;
			}

			final merged = List.of(state.items)..addAll(items);

			// (opsional) debug cepat kalau mau dipakai:
			// debugPrint("PAR merge peek stateFirst5=${_first5IdsFrom(state.items)} newFirst5=${_first5IdsFrom(items)}");

			// dedupe (kalau kamu mau samain persis MV yang tanpa dedupe, biarkan commented)
			// final result = merged
			//     .whereWithIndex((e, index) =>
			//         merged.indexWhere((e2) => e2.asetParId == e.asetParId) == index)
			//     .toList();

			emit(state.copyWith(
				items: merged, // atau items: result,
				status: ListStatus.success,
				hal: state.hal + 1,
				hasReachedMax: false,
				isFetching: false,
			));

			_recomputeActiveAndFiles(emit);
		} catch (_) {
			// kalau error: isFetching false
			if (state.queryKey == keyAtRequest) {
				emit(state.copyWith(status: ListStatus.failure, isFetching: false));
			}
		}
	}


	/*
	Future<void> onFetchAsetParCari(
			FetchAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		// ✅ guard: kalau lagi loadingMore, jangan spam
		if (state.status == ListStatus.loadingMore) return;

		final repo = AsetParCariRepository();

		// FIRST LOAD
		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetParCari(state.statusId, state.searchText, 0);

			emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));

			_recomputeActiveAndFiles(emit);
			return;
		}

		// ✅ next page load: tandai loadingMore tapi JANGAN hapus items
		emit(state.copyWith(status: ListStatus.loadingMore));

		final items = await repo.getAsetParCari(state.statusId, state.searchText, state.hal);

		if (items.isEmpty) {
			emit(state.copyWith(
				hasReachedMax: true,
				status: ListStatus.success, // balik ke success
			));
			return;
		}

		final asetParCari = List.of(state.items)..addAll(items);

		final result = asetParCari
				.whereWithIndex((e, index) =>
		asetParCari.indexWhere((e2) => e2.asetParId == e.asetParId) == index)
				.toList();

		emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1,
		));

		_recomputeActiveAndFiles(emit);
	}
	*/

	Future<void> _onDebugFetchAsetParCari(
			DebugFetchAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		final repo = AsetParCariRepository();

		debugPrint("🏠 [DebugFetch] Mulai ambil data PAR untuk '${event.searchText}'...");

		try {
			final results = await repo.getAsetParCari(event.statusId, event.searchText, 0);

			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
			for (final i in results) {
				debugPrint("""
🏠 [Data PAR]
──────────────────────────────
• Alamat       : ${i.alamat}
• Currency     : ${i.curr}
• Polis No     : ${i.polisNo}
• Sum Insured  : ${i.sumInsured}
• Premi        : ${i.premi}
• Status       : ${i.status}
• fileParId    : ${i.filePolisParId}
• fileEqId     : ${i.filePolisEqId}
──────────────────────────────
""");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error: $e");
			debugPrint(stack.toString());
		}
	}

	Future<void> onSelectDetail(
			SelectDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..add(event.asetParId);

		// 1) simpan selectedIds dulu
		emit(state.copyWith(selectedIds: updatedSelectedIds));

		// 2) jadikan id ini aktif dan turunkan filePar/fileEq dari items
		_recomputeActiveAndFiles(emit, preferId: event.asetParId);
	}

	Future<void> onSelectDetailId(
			SelectSingleParDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		emit(state.copyWith(
			selectedId: event.asetParId,
		));
		_recomputeSingleActiveAndFiles(
			emit,
			preferId: event.asetParId,
		);
	}

	Future<void> onUnselectDetail(
			UnselectDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..remove(event.asetParId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		// kalau yang dihapus adalah active, otomatis fallback ke sisa selection.
		// kalau bukan active, tetap mempertahankan active.
		final preferFallback =
		(state.activeAsetParId == event.asetParId) ? null : state.activeAsetParId;

		_recomputeActiveAndFiles(emit, preferId: preferFallback);
	}

	Future<void> onUnselectDetailParId(
			UnselectSingleParDetailEvent  event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedId != event.asetParId) return;

		emit(state.copyWith(
			selectedId: "",
		));
	}

	Future<void> onClearSelection(
			ClearParSelectionEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;

		emit(state.copyWith(
			selectedIds: <String>{},
			selectedId: "",
			activeAsetParId: "",
			selectedFilePolisParId: "",
			selectedFilePolisEqId: "",
		));
	}

	// -----------------------
	// Event filePar/fileEq (tetap ada, tapi "aman")
	// -----------------------

	Future<void> onSelectPolisParDetail(
			SelectPolisParDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		// Kalau UI masih ngirim, boleh saja overwrite.
		// Tapi selection logic kita akan menjaga konsistensi via _recomputeActiveAndFiles.
		emit(state.copyWith(selectedFilePolisParId: event.filePolisParId));
	}

	Future<void> onUnselectPolisParDetail(
			UnselectPolisParDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		// ❗JANGAN langsung kosongkan kalau masih ada selectedIds.
		// Karena nanti kasus "tinggal 1" bisa kosong padahal ada selection.
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisParId: ""));
			return;
		}

		// kalau masih ada selection, restore dari active/fallback
		_recomputeActiveAndFiles(emit);
	}

	Future<void> onClearPolisParSelection(
			ClearPolisParSelectionEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisParId: ""));
			return;
		}
		_recomputeActiveAndFiles(emit);
	}

	Future<void> onSelectPolisEqDetail(
			SelectPolisEqDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		emit(state.copyWith(selectedFilePolisEqId: event.filePolisEqId));
	}

	Future<void> onUnselectPolisEqDetail(
			UnselectPolisEqDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisEqId: ""));
			return;
		}
		_recomputeActiveAndFiles(emit);
	}

	Future<void> onClearPolisEqSelection(
			ClearPolisEqSelectionEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisEqId: ""));
			return;
		}
		_recomputeActiveAndFiles(emit);
	}

	AsetParCariModel? _findByAsetParId(String asetParId) {
		try {
			return state.items.firstWhere((e) => e.asetParId == asetParId);
		} catch (_) {
			return null;
		}
	}

	void _recomputeActiveAndFiles(Emitter<AsetParCariState> emit, {String? preferId}) {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(
				activeAsetParId: "",
				selectedFilePolisParId: "",
				selectedFilePolisEqId: "",
			));
			return;
		}

		String activeId = "";

		// 1) kalau ada preferId dan masih selected, pakai itu
		if (preferId != null && preferId.isNotEmpty && state.selectedIds.contains(preferId)) {
			activeId = preferId;
		}
		// 2) kalau active yang lama masih selected, pertahankan
		else if (state.activeAsetParId.isNotEmpty && state.selectedIds.contains(state.activeAsetParId)) {
			activeId = state.activeAsetParId;
		}
		// 3) fallback: ambil salah satu selected
		else {
			activeId = state.selectedIds.first;
		}

		final row = _findByAsetParId(activeId);

		emit(state.copyWith(
			activeAsetParId: activeId,
			selectedFilePolisParId: row?.filePolisParId ?? "",
			selectedFilePolisEqId: row?.filePolisEqId ?? "",
		));
	}

	void _recomputeSingleActiveAndFiles(
			Emitter<AsetParCariState> emit, {
				String? preferId,
			}) {
		final id = preferId ?? state.selectedId;

		if (id.isEmpty) {
			emit(state.copyWith(
				selectedId: "",
				activeAsetParId: "",
				selectedFilePolisParId: "",
				selectedFilePolisEqId: "",
			));
			return;
		}

		final row = _findByAsetParId(id);

		if (row == null) {
			emit(state.copyWith(
				selectedId: "",
				activeAsetParId: "",
				selectedFilePolisParId: "",
				selectedFilePolisEqId: "",
			));
			return;
		}

		emit(state.copyWith(
			selectedId: id,
			activeAsetParId: id,
			selectedFilePolisParId: row.filePolisParId,
			selectedFilePolisEqId: row.filePolisEqId,
		));
	}

}
