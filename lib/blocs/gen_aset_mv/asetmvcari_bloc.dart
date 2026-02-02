// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/widgets/list_extension.dart';
// import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';
// import 'package:joss_app/repositories/gen_aset_mv/asetmvcari_repository.dart';
//
// part 'asetmvcari_event.dart';
// part 'asetmvcari_state.dart';
//
// class AsetMvCariBloc extends Bloc<AsetMvCariEvents, AsetMvCariState> {
// 	AsetMvCariBloc() : super(const AsetMvCariState()) {
// 		on<FetchAsetMvCariEvent>(onFetchAsetMvCari);
// 		on<RefreshAsetMvCariEvent>(onRefreshAsetMvCari);
// 		on<DebugFetchAsetMvCariEvent>(_onDebugFetchAsetMvCari);
//
// 		on<SelectMvDetailEvent>(onSelectDetail);
// 		on<UnselectMvDetailEvent>(onUnselectDetail);
// 		on<ClearMvSelectionEvent>(onClearSelection);
//
// 		on<SelectPolisMvDetailEvent>(onSelectPolisMvDetail);
// 		on<UnselectPolisMvDetailEvent>(onUnselectPolisMvDetail);
// 		on<ClearPolisMvSelectionEvent>(onClearPolisMvSelection);
// 	}
//
// 	// 🔁 Normal Refresh
// 	Future<void> onRefreshAsetMvCari(
// 			RefreshAsetMvCariEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		emit(const AsetMvCariState());
//
// 		emit(state.copyWith(
// 			status: ListStatus.initial,
// 			items: const <AsetMvCariModel>[],
// 			hasReachedMax: false,
// 			hal: 0,
// 			searchText: event.searchText,
// 			statusId: event.statusId,
// 		));
//
// 		add(FetchAsetMvCariEvent());
// 	}
//
// 	// 📦 Normal Fetch (memperbarui tabel)
// 	Future<void> onFetchAsetMvCari(
// 			FetchAsetMvCariEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		if (state.hasReachedMax) return;
//
// 		final repo = AsetMvCariRepository();
//
// 		if (state.status == ListStatus.initial) {
// 			final items = await repo.getAsetMvCari(state.statusId, state.searchText, 0);
// 			return emit(state.copyWith(
// 				items: items,
// 				hasReachedMax: false,
// 				status: ListStatus.success,
// 				hal: 1,
// 			));
// 		}
//
// 		final items = await repo.getAsetMvCari(state.statusId, state.searchText, state.hal);
// 		if (items.isEmpty) {
// 			return emit(state.copyWith(hasReachedMax: true));
// 		} else {
// 			final asetMvCari = List.of(state.items)..addAll(items);
//
// 			final result = asetMvCari
// 					.whereWithIndex((e, index) =>
// 			asetMvCari.indexWhere((e2) => e2.asetMvId == e.asetMvId) == index)
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
// 	// 🧠 Debug Fetch (tidak trigger rebuild tabel)
// 	Future<void> _onDebugFetchAsetMvCari(
// 			DebugFetchAsetMvCariEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		final repo = AsetMvCariRepository();
//
// 		debugPrint("🚗 [DebugFetch] Mulai ambil data MV untuk '${event.searchText}'...");
//
// 		try {
// 			final results = await repo.getAsetMvCari(event.statusId, event.searchText, 0);
//
// 			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
// 			for (final i in results) {
// 				debugPrint("➡️ ${i.jenisMv} | Merk: ${i.merk} | Polis: ${i.polisNo} | Status: ${i.status}");
// 			}
// 			debugPrint("-----------------------------------------------------");
// 		} catch (e, stack) {
// 			debugPrint("💥 [DebugFetch] Error: $e");
// 			debugPrint(stack.toString());
// 		}
// 	}
//
// 	Future<void> onSelectDetail(
// 			SelectMvDetailEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..add(event.asetMvId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onUnselectDetail(
// 			UnselectMvDetailEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..remove(event.asetMvId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onClearSelection(
// 			ClearMvSelectionEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		if (state.selectedIds.isEmpty) return;
// 		emit(state.copyWith(selectedIds: <String>{}));
// 	}
//
// 	Future<void> onSelectPolisMvDetail(
// 			SelectPolisMvDetailEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: event.filePolisId,
// 		));
// 	}
//
// 	Future<void> onUnselectPolisMvDetail(
// 			UnselectPolisMvDetailEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisMvSelection(
// 			ClearPolisMvSelectionEvent event,
// 			Emitter<AsetMvCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
// }


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_mv/asetmvcari_model.dart';
import 'package:joss_app/repositories/gen_aset_mv/asetmvcari_repository.dart';

part 'asetmvcari_event.dart';
part 'asetmvcari_state.dart';

class AsetMvCariBloc extends Bloc<AsetMvCariEvents, AsetMvCariState> {
	AsetMvCariBloc() : super(const AsetMvCariState()) {
		on<FetchAsetMvCariEvent>(onFetchAsetMvCari);
		on<RefreshAsetMvCariEvent>(onRefreshAsetMvCari);
		on<DebugFetchAsetMvCariEvent>(_onDebugFetchAsetMvCari);

		on<SelectMvDetailEvent>(onSelectDetail);
		on<UnselectMvDetailEvent>(onUnselectDetail);
		on<ClearMvSelectionEvent>(onClearSelection);

		// UI masih ngirim event ini? gapapa, tapi handler kita bikin aman
		on<SelectPolisMvDetailEvent>(onSelectPolisMvDetail);
		on<UnselectPolisMvDetailEvent>(onUnselectPolisMvDetail);
		on<ClearPolisMvSelectionEvent>(onClearPolisMvSelection);

		on<SelectSingleMvDetailEvent>(onSelectDetailMvId);
		on<UnselectSingleMvDetailEvent>(onUnselectDetailMvId);
		on<SelectMvCariEvent>((event, emit) {
			emit(state.copyWith(selectedItem: event.selectedItem));
		});
	}

	// -----------------------
	// Helpers
	// -----------------------

	AsetMvCariModel? _findByAsetMvId(String asetMvId) {
		try {
			return state.items.firstWhere((e) => e.asetMvId == asetMvId);
		} catch (_) {
			return null;
		}
	}

	/// Menentukan activeAsetMvId dan turunkan selectedFilePolisId dari items.
	void _recomputeActiveAndFile(Emitter<AsetMvCariState> emit, {String? preferId}) {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(
				activeAsetMvId: "",
				selectedFilePolisId: "",
			));
			return;
		}

		String activeId = "";

		// 1) preferId kalau masih selected
		if (preferId != null && preferId.isNotEmpty && state.selectedIds.contains(preferId)) {
			activeId = preferId;
		}
		// 2) pertahankan active lama kalau masih selected
		else if (state.activeAsetMvId.isNotEmpty && state.selectedIds.contains(state.activeAsetMvId)) {
			activeId = state.activeAsetMvId;
		}
		// 3) fallback: ambil salah satu selected
		else {
			activeId = state.selectedIds.first;
		}

		final row = _findByAsetMvId(activeId);

		emit(state.copyWith(
			activeAsetMvId: activeId,
			selectedFilePolisId: row?.filePolisId ?? "",
		));
	}

	// -----------------------
	// Refresh / Fetch
	// -----------------------

	Future<void> onRefreshAsetMvCari(
			RefreshAsetMvCariEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		// ✅ Fix C: jangan clear items biar nggak kedip.
		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			searchText: event.searchText,
			statusId: event.statusId,
			// items tetap
		));

		add(FetchAsetMvCariEvent());
	}

	Future<void> onFetchAsetMvCari(
			FetchAsetMvCariEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetMvCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetMvCari(state.statusId, state.searchText, 0);
			emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));

			// setelah items update, pastikan active/file masih valid
			_recomputeActiveAndFile(emit);
			return;
		}

		final items = await repo.getAsetMvCari(state.statusId, state.searchText, state.hal);
		if (items.isEmpty) {
			emit(state.copyWith(hasReachedMax: true));
			return;
		}

		final asetMvCari = List.of(state.items)..addAll(items);

		final result = asetMvCari
				.whereWithIndex((e, index) =>
		asetMvCari.indexWhere((e2) => e2.asetMvId == e.asetMvId) == index)
				.toList();

		emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1,
		));

		_recomputeActiveAndFile(emit);
	}

	// -----------------------
	// Selection utama
	// -----------------------

	Future<void> onSelectDetail(
			SelectMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..add(event.asetMvId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		// id yang baru dipilih jadi active
		_recomputeActiveAndFile(emit, preferId: event.asetMvId);
	}

	Future<void> onUnselectDetail(
			UnselectMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..remove(event.asetMvId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		// kalau yang dihapus adalah active, otomatis fallback
		final preferFallback =
		(state.activeAsetMvId == event.asetMvId) ? null : state.activeAsetMvId;

		_recomputeActiveAndFile(emit, preferId: preferFallback);
	}

	Future<void> onClearSelection(
			ClearMvSelectionEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;

		emit(state.copyWith(
			selectedIds: <String>{},
			activeAsetMvId: "",
			selectedFilePolisId: "",
			selectedId: ""
		));
	}

	// -----------------------
	// Event file polis (masih ada, tapi dibuat aman)
	// -----------------------

	Future<void> onSelectPolisMvDetail(
			SelectPolisMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		// UI masih ngirim? ok, boleh overwrite.
		emit(state.copyWith(selectedFilePolisId: event.filePolisId));
	}

	Future<void> onUnselectPolisMvDetail(
			UnselectPolisMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		// ❗jangan bikin kosong kalau masih ada selection
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onClearPolisMvSelection(
			ClearPolisMvSelectionEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onSelectDetailMvId(
			SelectSingleMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		emit(state.copyWith(
			selectedId: event.asetMvId,
		));
	}
	
	Future<void> onUnselectDetailMvId(
			UnselectSingleMvDetailEvent  event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.selectedId != event.asetMvId) return;

		emit(state.copyWith(
			selectedId: "",
		));
	}
	// -----------------------
	// Debug fetch tetap sama
	// -----------------------
	Future<void> _onDebugFetchAsetMvCari(
			DebugFetchAsetMvCariEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		final repo = AsetMvCariRepository();

		debugPrint("🚗 [DebugFetch] Mulai ambil data MV untuk '${event.searchText}'...");

		try {
			final results = await repo.getAsetMvCari(event.statusId, event.searchText, 0);

			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
			for (final i in results) {
				debugPrint("➡️ ${i.jenisMv} | Merk: ${i.merk} | Polis: ${i.polisNo} | Status: ${i.status} | filePolisId: ${i.filePolisId}");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error: $e");
			debugPrint(stack.toString());
		}
	}
}
