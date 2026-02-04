import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/asetothers/asetotherscari_model.dart';
import 'package:joss_app/repositories/asetothers/asetotherscari_repository.dart';

part 'asetotherscari_event.dart';
part 'asetotherscari_state.dart';

// class AsetothersCariBloc extends Bloc<AsetothersCariEvents, AsetothersCariState> {
// 	AsetothersCariBloc() : super(const AsetothersCariState()) {
// 		on<FetchAsetothersCariEvent>(onFetchAsetothersCari);
// 		on<RefreshAsetothersCariEvent>(onRefreshAsetothersCari);
// 		on<SelectOthersDetailEvent>(onSelectDetail);
// 		on<UnselectOthersDetailEvent>(onUnselectDetail);
// 		on<ClearOthersSelectionEvent>(onClearSelection);
//
// 		on<SelectPolisOthersDetailEvent>(onSelectPolisOthersDetail);
// 		on<UnselectPolisOthersDetailEvent>(onUnselectPolisOthersDetail);
// 		on<ClearPolisOthersSelectionEvent>(onClearPolisOthersSelection);
// 	}
//
// Future<void> onRefreshAsetothersCari(
// 		RefreshAsetothersCariEvent event, Emitter<AsetothersCariState> emit) async {
// 	emit(const AsetothersCariState());
//   emit(state.copyWith(statusId: event.statusId, cobId: event.cobId, searchText: event.searchText));
// 	add(FetchAsetothersCariEvent());
// }
//
// Future<void> onFetchAsetothersCari(
// 		FetchAsetothersCariEvent event, Emitter<AsetothersCariState> emit) async {
// 	if (state.hasReachedMax) return;
//
// 	AsetothersCariRepository repo = AsetothersCariRepository();
// 	if (state.status == ListStatus.initial) {
// 		List<AsetothersCariModel> items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, 0);
// 		return emit(state.copyWith(
// 			items: items,
// 			hasReachedMax: false,
// 			status: ListStatus.success,
// 			hal: 1));
// 	}
// 	List<AsetothersCariModel> items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, state.hal);
// 	if (items.isEmpty) {
// 		return emit(state.copyWith(hasReachedMax: true));
// 	} else {
// 		List<AsetothersCariModel> asetothersCari = List.of(state.items)..addAll(items);
//
// 		final result = asetothersCari
// 			.whereWithIndex((e, index) =>
// 				asetothersCari.indexWhere((e2) => e2.asetOthersId == e.asetOthersId) ==
// 				index)
// 			.toList();
//
// 		return emit(state.copyWith(
// 			items: result,
// 			hasReachedMax: false,
// 			status: ListStatus.success,
// 			hal: state.hal + 1));
// 		}
// 	}
//
// 	Future<void> onSelectDetail(
// 			SelectOthersDetailEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..add(event.asetOthersId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onUnselectDetail(
// 			UnselectOthersDetailEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		final updatedSelectedIds = Set<String>.from(state.selectedIds)
// 			..remove(event.asetOthersId);
//
// 		emit(state.copyWith(selectedIds: updatedSelectedIds));
// 	}
//
// 	Future<void> onClearSelection(
// 			ClearOthersSelectionEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		if (state.selectedIds.isEmpty) return;
// 		emit(state.copyWith(selectedIds: <String>{}));
// 	}
//
//
// 	Future<void> onSelectPolisOthersDetail(
// 			SelectPolisOthersDetailEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: event.filePolisId,
// 		));
// 	}
//
// 	Future<void> onUnselectPolisOthersDetail(
// 			UnselectPolisOthersDetailEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
//
// 	Future<void> onClearPolisOthersSelection(
// 			ClearPolisOthersSelectionEvent event,
// 			Emitter<AsetothersCariState> emit,
// 			) async {
// 		if (state.selectedFilePolisId.isEmpty) return;
// 		emit(state.copyWith(
// 			selectedFilePolisId: "",
// 		));
// 	}
// }
class AsetothersCariBloc extends Bloc<AsetothersCariEvents, AsetothersCariState> {
	AsetothersCariBloc() : super(const AsetothersCariState()) {
		on<FetchAsetothersCariEvent>(onFetchAsetothersCari);
		on<RefreshAsetothersCariEvent>(onRefreshAsetothersCari);

		on<SelectOthersDetailEvent>(onSelectDetail);
		on<UnselectOthersDetailEvent>(onUnselectDetail);
		on<ClearOthersSelectionEvent>(onClearSelection);

		// UI masih ngirim? tetap ada, tapi kita bikin aman
		on<SelectPolisOthersDetailEvent>(onSelectPolisOthersDetail);
		on<UnselectPolisOthersDetailEvent>(onUnselectPolisOthersDetail);
		on<ClearPolisOthersSelectionEvent>(onClearPolisOthersSelection);

		on<SelectSingleOthersDetailEvent>(onSelectDetailOthersId);
		on<UnselectSingleOthersDetailEvent>(onUnselectDetailOthersId);
		on<SelectOthersCariEvent>((event, emit) {
			emit(state.copyWith(selectedItem: event.selectedItem));
		});
		on<SelectProsesOthersIdEvent>((event, emit) {
			emit(state.copyWith(selectedProsesId: event.prosesId));
		});
	}

	// -----------------------
	// Helpers
	// -----------------------
	AsetothersCariModel? _findByAsetOthersId(String id) {
		try {
			return state.items.firstWhere((e) => e.asetOthersId == id);
		} catch (_) {
			return null;
		}
	}

	void _recomputeActiveAndFile(Emitter<AsetothersCariState> emit, {String? preferId}) {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(
				activeAsetOthersId: "",
				selectedFilePolisId: "",
			));
			return;
		}

		String activeId = "";

		if (preferId != null && preferId.isNotEmpty && state.selectedIds.contains(preferId)) {
			activeId = preferId;
		} else if (state.activeAsetOthersId.isNotEmpty && state.selectedIds.contains(state.activeAsetOthersId)) {
			activeId = state.activeAsetOthersId;
		} else {
			activeId = state.selectedIds.first;
		}

		final row = _findByAsetOthersId(activeId);

		emit(state.copyWith(
			activeAsetOthersId: activeId,
			selectedFilePolisId: row?.filePolisId ?? "",
		));
	}

	// -----------------------
	// Refresh / Fetch
	// -----------------------
	Future<void> onRefreshAsetothersCari(
			RefreshAsetothersCariEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		// ✅ Fix C: jangan emit(const ...) biar gak kedip
		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			statusId: event.statusId,
			cobId: event.cobId,
			searchText: event.searchText,
			// items tetap
		));

		add(FetchAsetothersCariEvent());
	}

	Future<void> onFetchAsetothersCari(
			FetchAsetothersCariEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetothersCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, 0);

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

		final items = await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, state.hal);
		if (items.isEmpty) {
			emit(state.copyWith(hasReachedMax: true));
			return;
		}

		final asetothersCari = List.of(state.items)..addAll(items);

		final result = asetothersCari
				.whereWithIndex((e, index) =>
		asetothersCari.indexWhere((e2) => e2.asetOthersId == e.asetOthersId) == index)
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
			SelectOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..add(event.asetOthersId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		_recomputeActiveAndFile(emit, preferId: event.asetOthersId);
	}

	Future<void> onUnselectDetail(
			UnselectOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)..remove(event.asetOthersId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));

		final preferFallback =
		(state.activeAsetOthersId == event.asetOthersId) ? null : state.activeAsetOthersId;

		_recomputeActiveAndFile(emit, preferId: preferFallback);
	}

	Future<void> onClearSelection(
			ClearOthersSelectionEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;

		emit(state.copyWith(
			selectedIds: <String>{},
			activeAsetOthersId: "",
			selectedFilePolisId: "",
				selectedId: ""
		));
	}

	// -----------------------
	// Event file polis (masih ada, tapi aman)
	// -----------------------
	Future<void> onSelectPolisOthersDetail(
			SelectPolisOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		emit(state.copyWith(selectedFilePolisId: event.filePolisId));
	}

	Future<void> onUnselectPolisOthersDetail(
			UnselectPolisOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		// ❗ jangan kosongkan kalau masih ada selection
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onClearPolisOthersSelection(
			ClearPolisOthersSelectionEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) {
			emit(state.copyWith(selectedFilePolisId: ""));
			return;
		}
		_recomputeActiveAndFile(emit);
	}

	Future<void> onSelectDetailOthersId(
			SelectSingleOthersDetailEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		emit(state.copyWith(
			selectedId: event.asetOthersId,
		));
	}

	Future<void> onUnselectDetailOthersId(
			UnselectSingleOthersDetailEvent  event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.selectedId != event.asetOthersId) return;

		emit(state.copyWith(
			selectedId: "",
		));
	}
}
