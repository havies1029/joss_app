import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';
import 'package:joss_app/repositories/gen_aset_health/asethealthcari_repository.dart';

part 'asethealthcari_event.dart';
part 'asethealthcari_state.dart';
//
// class AsetHealthCariBloc extends Bloc<AsetHealthCariEvents, AsetHealthCariState> {
// 	AsetHealthCariBloc() : super(const AsetHealthCariState()) {
// 		on<FetchAsetHealthCariEvent>(onFetchAsetHealthCari);
// 		on<RefreshAsetHealthCariEvent>(onRefreshAsetHealthCari);
// 		on<DebugFetchAsetHealthCariEvent>(_onDebugFetchAsetHealthCari);
//
// 		on<SelectHealthDetailEvent>(onSelectDetail);
// 		on<UnselectHealthDetailEvent>(onUnselectDetail);
// 		on<ClearHealthSelectionEvent>(onClearSelection);
//
// 		on<SelectPolisHealthDetailEvent>(onSelectPolisHealthDetail);
// 		on<UnselectPolisHealthDetailEvent>(onUnselectPolisHealthDetail);
// 		on<ClearPolisHealthSelectionEvent>(onClearPolisHealthSelection);
// 	}
//
// 	// 🔁 Normal Refresh (memperbarui tabel)
// 	Future<void> onRefreshAsetHealthCari(
// 			RefreshAsetHealthCariEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		emit(const AsetHealthCariState());
// 		emit(state.copyWith(statusId: event.statusId, searchText: event.searchText));
// 		add(FetchAsetHealthCariEvent());
// 	}
//
// 	// 📦 Normal Fetch (memperbarui state)
// 	Future<void> onFetchAsetHealthCari(
// 			FetchAsetHealthCariEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		if (state.hasReachedMax) return;
//
// 		final repo = AsetHealthCariRepository();
//
// 		if (state.status == ListStatus.initial) {
// 			final items = await repo.getAsetHealthCari(
// 				state.statusId,
// 				state.searchText,
// 				0,
// 			);
//
// 			return emit(state.copyWith(
// 				items: items,
// 				hasReachedMax: false,
// 				status: ListStatus.success,
// 				hal: 1,
// 			));
// 		}
//
// 		final items = await repo.getAsetHealthCari(
// 			state.statusId,
// 			state.searchText,
// 			state.hal,
// 		);
//
// 		if (items.isEmpty) {
// 			return emit(state.copyWith(hasReachedMax: true));
// 		} else {
// 			final asetHealthCari = List.of(state.items)..addAll(items);
//
// 			final result = asetHealthCari
// 					.whereWithIndex(
// 						(e, index) =>
// 				asetHealthCari.indexWhere(
// 								(e2) => e2.asethealthId == e.asethealthId) ==
// 						index,
// 			)
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
//
// 	// 🧠 Debug Fetch (tidak mengubah state UI)
// 	Future<void> _onDebugFetchAsetHealthCari(
// 			DebugFetchAsetHealthCariEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		final repo = AsetHealthCariRepository();
//
// 		debugPrint("🔍 [DebugFetch] Memulai fetch debug untuk '${event.searchText}'...");
//
// 		try {
// 			final results = await repo.getAsetHealthCari(event.statusId, event.searchText, 0);
//
// 			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
// 			for (final i in results) {
// 				debugPrint("➡️ ${i.nama} | Polis: ${i.polisNo} | Status: ${i.status}");
// 			}
// 			debugPrint("-----------------------------------------------------");
// 		} catch (e, stack) {
// 			debugPrint("💥 [DebugFetch] Error: $e");
// 			debugPrint(stack.toString());
// 		}
// 	}
//
// 	Future<void> onSelectDetail(
// 			SelectHealthDetailEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..add(event.asethealthId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onUnselectDetail(
// 			UnselectHealthDetailEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..remove(event.asethealthId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onClearSelection(
// 			ClearHealthSelectionEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		if (state.selectedIds.isEmpty) return;
// 		emit(state.copyWith(selectedIds: <String>{}));
// 	}
//
//
// 	Future<void> onSelectPolisHealthDetail(
// 			SelectPolisHealthDetailEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: event.filePolisId,
// 		));
// 	}
//
// 	Future<void> onUnselectPolisHealthDetail(
// 			UnselectPolisHealthDetailEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisHealthSelection(
// 			ClearPolisHealthSelectionEvent event,
// 			Emitter<AsetHealthCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
// }

class AsetHealthCariBloc extends Bloc<AsetHealthCariEvents, AsetHealthCariState> {
	AsetHealthCariBloc() : super(const AsetHealthCariState()) {
		on<FetchAsetHealthCariEvent>(onFetchAsetHealthCari);
		on<RefreshAsetHealthCariEvent>(onRefreshAsetHealthCari);
		on<DebugFetchAsetHealthCariEvent>(_onDebugFetchAsetHealthCari);

		on<SelectHealthDetailEvent>(onSelectDetail);
		on<UnselectHealthDetailEvent>(onUnselectDetail);
		on<ClearHealthSelectionEvent>(onClearSelection);

		// UI masih ngirim? tetap diterima, tapi kita bikin aman
		on<SelectPolisHealthDetailEvent>(onSelectPolisHealthDetail);
		on<UnselectPolisHealthDetailEvent>(onUnselectPolisHealthDetail);
		on<ClearPolisHealthSelectionEvent>(onClearPolisHealthSelection);

		on<SelectSingleHealthDetailEvent>(onSelectDetailHealthId);
		on<UnselectSingleHealthDetailEvent>(onUnselectDetailHealthId);
	}

	// -----------------------
	// Helpers
	// -----------------------

	AsetHealthCariModel? _findByAsetHealthId(String id) {
		try {
			return state.items.firstWhere((e) => e.asethealthId == id);
		} catch (_) {
			return null;
		}
	}

	void _recomputeActiveAndFile(Emitter<AsetHealthCariState> emit, {String? preferId}) {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(
				activeAsetHealthId: "",
				selectedFilePolisId: "",
			));
			return;
		}

		String activeId = "";

		if (preferId != null && preferId.isNotEmpty && state.selectedIds.contains(preferId)) {
			activeId = preferId;
		} else if (state.activeAsetHealthId.isNotEmpty && state.selectedIds.contains(state.activeAsetHealthId)) {
			activeId = state.activeAsetHealthId;
		} else {
			activeId = state.selectedIds.first;
		}

		final row = _findByAsetHealthId(activeId);

		emit(state.copyWith(
			activeAsetHealthId: activeId,
			selectedFilePolisId: row?.filePolisId ?? "",
		));
	}

	// -----------------------
	// Refresh / Fetch
	// -----------------------

	Future<void> onRefreshAsetHealthCari(
			RefreshAsetHealthCariEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		// ✅ Fix C: jangan emit(const State()) supaya UI nggak kedip kosong
		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			statusId: event.statusId,
			searchText: event.searchText,
			// items tetap
		));

		add(FetchAsetHealthCariEvent());
	}

	Future<void> onFetchAsetHealthCari(
			FetchAsetHealthCariEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetHealthCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetHealthCari(state.statusId, state.searchText, 0);

			emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));

			// jaga active/file kalau ada selected
			_recomputeActiveAndFile(emit);
			return;
		}

		final items = await repo.getAsetHealthCari(state.statusId, state.searchText, state.hal);

		if (items.isEmpty) {
			emit(state.copyWith(hasReachedMax: true));
			return;
		}

		final asetHealthCari = List.of(state.items)..addAll(items);

		final result = asetHealthCari
				.whereWithIndex((e, index) =>
		asetHealthCari.indexWhere((e2) => e2.asethealthId == e.asethealthId) == index)
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
	// Debug Fetch (tetap)
	// -----------------------
	Future<void> _onDebugFetchAsetHealthCari(
			DebugFetchAsetHealthCariEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		final repo = AsetHealthCariRepository();

		debugPrint("🔍 [DebugFetch] Memulai fetch debug untuk '${event.searchText}'...");

		try {
			final results = await repo.getAsetHealthCari(event.statusId, event.searchText, 0);

			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
			for (final i in results) {
				debugPrint("➡️ ${i.nama} | Polis: ${i.polisNo} | Status: ${i.status} | filePolisId: ${i.filePolisId}");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error: $e");
			debugPrint(stack.toString());
		}
	}

	// -----------------------
	// Selection utama
	// -----------------------
	Future<void> onSelectDetail(
			SelectHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..add(event.asethealthId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		_recomputeActiveAndFile(emit, preferId: event.asethealthId);
	}

	Future<void> onUnselectDetail(
			UnselectHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..remove(event.asethealthId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		final preferFallback =
		(state.activeAsetHealthId == event.asethealthId) ? null : state.activeAsetHealthId;

		_recomputeActiveAndFile(emit, preferId: preferFallback);
	}

	Future<void> onClearSelection(
			ClearHealthSelectionEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;

		emit(state.copyWith(
			selectedIds: <String>{},
			activeAsetHealthId: "",
			selectedFilePolisId: "",
				selectedId: ""
		));
	}

	// -----------------------
	// Event file polis (masih ada, tapi aman)
	// -----------------------
	Future<void> onSelectPolisHealthDetail(
			SelectPolisHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		emit(state.copyWith(selectedFilePolisId: event.filePolisId));
	}

	Future<void> onUnselectPolisHealthDetail(
			UnselectPolisHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onClearPolisHealthSelection(
			ClearPolisHealthSelectionEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onSelectDetailHealthId(
			SelectSingleHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		emit(state.copyWith(
			selectedId: event.asetHealthId,
		));
	}

	Future<void> onUnselectDetailHealthId(
			UnselectSingleHealthDetailEvent  event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.selectedId != event.asetHealthId) return;

		emit(state.copyWith(
			selectedId: "",
		));
	}
}
