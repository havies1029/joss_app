import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_hull/asethullcari_model.dart';
import 'package:joss_app/repositories/gen_aset_hull/asethullcari_repository.dart';

part 'asethullcari_event.dart';
part 'asethullcari_state.dart';
//
// class AsethullCariBloc extends Bloc<AsethullCariEvents, AsethullCariState> {
// 	AsethullCariBloc() : super(const AsethullCariState()) {
// 		on<FetchAsethullCariEvent>(onFetchAsethullCari);
// 		on<RefreshAsethullCariEvent>(onRefreshAsethullCari);
// 		on<DebugFetchAsethullCariEvent>(_onDebugFetchAsethullCari);
//
// 		on<SelectHullDetailEvent>(onSelectDetail);
// 		on<UnselectHullDetailEvent>(onUnselectDetail);
// 		on<ClearHullSelectionEvent>(onClearSelection);
//
// 		on<SelectPolisHullDetailEvent>(onSelectPolisHullrDetail);
// 		on<UnselectPolisHullDetailEvent>(onUnselectPolisHullDetail);
// 		on<ClearPolisHullSelectionEvent>(onClearPolisHullSelection);
// 	}
//
// Future<void> onRefreshAsethullCari(
// 		RefreshAsethullCariEvent event, Emitter<AsethullCariState> emit) async {
// 	emit(const AsethullCariState());
//
//   emit(state.copyWith(statusId: event.statusId, searchText: event.searchText));
//
// 	add(FetchAsethullCariEvent());
// }
//
// Future<void> onFetchAsethullCari(
// 		FetchAsethullCariEvent event, Emitter<AsethullCariState> emit) async {
// 	if (state.hasReachedMax) return;
//
// 	AsethullCariRepository repo = AsethullCariRepository();
// 	if (state.status == ListStatus.initial) {
// 		List<AsethullCariModel> items = await repo.getAsethullCari(state.statusId, state.searchText, 0);
// 		return emit(state.copyWith(
// 			items: items,
// 			hasReachedMax: false,
// 			status: ListStatus.success,
//       hal: 1
// 			));
// 	}
// 	List<AsethullCariModel> items = await repo.getAsethullCari(state.statusId, state.searchText, state.hal);
// 	if (items.isEmpty) {
// 		return emit(state.copyWith(hasReachedMax: true));
// 	} else {
// 		List<AsethullCariModel> asethullCari = List.of(state.items)..addAll(items);
//
// 		final result = asethullCari
// 			.whereWithIndex((e, index) =>
// 				asethullCari.indexWhere((e2) => e2.asetHullId == e.asetHullId) ==
// 				index)
// 			.toList();
//
// 		return emit(state.copyWith(
// 			items: result,
// 			hasReachedMax: false,
// 			status: ListStatus.success,
//       hal: state.hal + 1
// 			));
// 		}
//
// 	}
//
// 	Future<void> _onDebugFetchAsethullCari(
// 			DebugFetchAsethullCariEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		final repo = AsethullCariRepository();
//
// 		debugPrint("🚢 [DebugFetch] Mulai ambil data Hull untuk '${event.searchText}'...");
//
// 		try {
// 			final results = await repo.getAsethullCari(
// 				event.statusId,
// 				event.searchText,
// 				0, // offset awal
// 			);
//
// 			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
// 			for (final i in results) {
// 				debugPrint("⚓ Nama Kapal: ${i.namaKapal} | Polis: ${i.polisNo} | Curr: ${i.curr} | "
// 						"Premi: ${i.premi} | TSI: ${i.tsi} | Status: ${i.status}");
// 			}
// 			debugPrint("-----------------------------------------------------");
// 		} catch (e, stack) {
// 			debugPrint("💥 [DebugFetch] Error saat ambil data Hull: $e");
// 			debugPrint(stack.toString());
// 		}
// 	}
//
// 	Future<void> onSelectDetail(
// 			SelectHullDetailEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..add(event.asetHullId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onUnselectDetail(
// 			UnselectHullDetailEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..remove(event.asetHullId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onClearSelection(
// 			ClearHullSelectionEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		if (state.selectedIds.isEmpty) return;
// 		emit(state.copyWith(selectedIds: <String>{}));
// 	}
//
// 	Future<void> onSelectPolisHullrDetail(
// 			SelectPolisHullDetailEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: event.filePolisId,
// 		));
// 	}
//
// 	Future<void> onUnselectPolisHullDetail(
// 			UnselectPolisHullDetailEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisHullSelection(
// 			ClearPolisHullSelectionEvent event,
// 			Emitter<AsethullCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
// }

class AsethullCariBloc extends Bloc<AsethullCariEvents, AsethullCariState> {
	AsethullCariBloc() : super(const AsethullCariState()) {
		on<FetchAsethullCariEvent>(onFetchAsethullCari);
		on<RefreshAsethullCariEvent>(onRefreshAsethullCari);
		on<DebugFetchAsethullCariEvent>(_onDebugFetchAsethullCari);

		on<SelectHullDetailEvent>(onSelectDetail);
		on<UnselectHullDetailEvent>(onUnselectDetail);
		on<ClearHullSelectionEvent>(onClearSelection);

		on<SelectPolisHullDetailEvent>(onSelectPolisHullDetail);
		on<UnselectPolisHullDetailEvent>(onUnselectPolisHullDetail);
		on<ClearPolisHullSelectionEvent>(onClearPolisHullSelection);
		on<SelectHullCariEvent>((event, emit) {
			emit(state.copyWith(selectedItem: event.selectedItem));
		});
	}

	// -----------------------
	// Helpers
	// -----------------------

	AsethullCariModel? _findByAsetHullId(String asetHullId) {
		try {
			return state.items.firstWhere((e) => e.asetHullId == asetHullId);
		} catch (_) {
			return null;
		}
	}

	void _recomputeActiveAndFile(Emitter<AsethullCariState> emit, {String? preferId}) {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(
				activeAsetHullId: "",
				selectedFilePolisId: "",
			));
			return;
		}

		String activeId = "";

		if (preferId != null && preferId.isNotEmpty && state.selectedIds.contains(preferId)) {
			activeId = preferId;
		} else if (state.activeAsetHullId.isNotEmpty && state.selectedIds.contains(state.activeAsetHullId)) {
			activeId = state.activeAsetHullId;
		} else {
			activeId = state.selectedIds.first;
		}

		final row = _findByAsetHullId(activeId);

		emit(state.copyWith(
			activeAsetHullId: activeId,
			selectedFilePolisId: row?.filePolisId ?? "",
		));
	}

	// -----------------------
	// Refresh / Fetch
	// -----------------------

	Future<void> onRefreshAsethullCari(
			RefreshAsethullCariEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		// ✅ Fix C: jangan emit(const State()) karena itu ngilangin items dan bikin kedip.
		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			statusId: event.statusId,
			searchText: event.searchText,
			// items tetap
		));

		add(FetchAsethullCariEvent());
	}

	Future<void> onFetchAsethullCari(
			FetchAsethullCariEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsethullCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsethullCari(state.statusId, state.searchText, 0);
			emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));

			// setelah items update, jaga active/file kalau ada selected
			_recomputeActiveAndFile(emit);
			return;
		}

		final items = await repo.getAsethullCari(state.statusId, state.searchText, state.hal);
		if (items.isEmpty) {
			emit(state.copyWith(hasReachedMax: true));
			return;
		}

		final asetHullCari = List.of(state.items)..addAll(items);

		final result = asetHullCari
				.whereWithIndex((e, index) =>
		asetHullCari.indexWhere((e2) => e2.asetHullId == e.asetHullId) == index)
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
	// Debug Fetch
	// -----------------------
	Future<void> _onDebugFetchAsethullCari(
			DebugFetchAsethullCariEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		final repo = AsethullCariRepository();

		debugPrint("🚢 [DebugFetch] Mulai ambil data Hull untuk '${event.searchText}'...");

		try {
			final results = await repo.getAsethullCari(event.statusId, event.searchText, 0);

			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
			for (final i in results) {
				debugPrint(
					"⚓ Nama Kapal: ${i.namaKapal} | Polis: ${i.polisNo} | Curr: ${i.curr} | "
							"Premi: ${i.premi} | TSI: ${i.tsi} | Status: ${i.status} | filePolisId: ${i.filePolisId}",
				);
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error saat ambil data Hull: $e");
			debugPrint(stack.toString());
		}
	}

	// -----------------------
	// Selection utama
	// -----------------------
	Future<void> onSelectDetail(
			SelectHullDetailEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..add(event.asetHullId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		_recomputeActiveAndFile(emit, preferId: event.asetHullId);
	}

	Future<void> onUnselectDetail(
			UnselectHullDetailEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..remove(event.asetHullId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		final preferFallback =
		(state.activeAsetHullId == event.asetHullId) ? null : state.activeAsetHullId;

		_recomputeActiveAndFile(emit, preferId: preferFallback);
	}

	Future<void> onClearSelection(
			ClearHullSelectionEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;

		emit(state.copyWith(
			selectedIds: <String>{},
			activeAsetHullId: "",
			selectedFilePolisId: "",
				selectedId: ""
		));
	}

	// -----------------------
	// Event file polis (masih ada, tapi aman)
	// -----------------------
	Future<void> onSelectPolisHullDetail(
			SelectPolisHullDetailEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		// UI masih kirim? boleh overwrite.
		emit(state.copyWith(selectedFilePolisId: event.filePolisId));
	}

	Future<void> onUnselectPolisHullDetail(
			UnselectPolisHullDetailEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		// ❗ jangan kosongkan kalau masih ada selection
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onClearPolisHullSelection(
			ClearPolisHullSelectionEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onSelectDetailHullId(
			SelectSingleHullDetailEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		emit(state.copyWith(
			selectedId: event.asetHullId,
		));
	}

	Future<void> onUnselectDetailHullId(
			UnselectSingleHullDetailEvent  event,
			Emitter<AsethullCariState> emit,
			) async {
		if (state.selectedId != event.asetHullId) return;

		emit(state.copyWith(
			selectedId: "",
		));
	}
}
