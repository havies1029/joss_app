import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/asetothers/asetotherscari_model.dart';
import 'package:joss_app/repositories/asetothers/asetotherscari_repository.dart';

part 'asetotherscari_event.dart';
part 'asetotherscari_state.dart';

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
		on<ClearSelectedOthersItemEvent>((event, emit) {
			emit(state.copyWith(selectedItem: null));
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

	String buildKey({required String search, required String statusId, String? cobId}) {
		final s = search.trim().toLowerCase();
		final c = cobId ?? '';
		return '$s|$c|$statusId';
	}

	Future<void> onRefreshAsetothersCari(
			RefreshAsetothersCariEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		// ✅ Fix C: jangan emit(const ...) biar gak kedip
		final newKey = buildKey(search: event.searchText, statusId: event.statusId, cobId: event.cobId);

		emit(state.copyWith(
			status: ListStatus.initial,
			hasReachedMax: false,
			hal: 0,
			searchText: event.searchText,
			cobId: event.cobId,
			statusId: event.statusId,
			queryKey: newKey,
			// items: state.items  // tetap biar ga kedip
		));

		add(FetchAsetothersCariEvent());
	}

	Future<void> onFetchAsetothersCari(
			FetchAsetothersCariEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.isFetching) return;

		final repo = AsetothersCariRepository();
		final keyAtRequest = state.queryKey;

		emit(state.copyWith(isFetching: true));

		try {
			final nextHal = state.hal; // 0 untuk first page, dst.
			debugPrint("getAsetothersCari di trigger");
			final items = await repo.getAsetothersCari(
				state.cobId,
				state.statusId,
				state.searchText,
				nextHal,
			);

			// kalau query berubah saat nunggu -> buang hasil
			if (state.queryKey != keyAtRequest) return;

			// helper ambil 5 id pertama (biar kelihatan nyampur apa enggak)
			List<String> _first5IdsFrom(List<AsetothersCariModel> list) {
				return list
						.take(5)
						.map((e) => e.asetOthersId) // ganti kalau field id kamu beda
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
				_recomputeActiveAndFile(emit);
				return;
			}

			if (items.isEmpty) {
				emit(state.copyWith(hasReachedMax: true, isFetching: false));
				return;
			}

			final merged = List.of(state.items)..addAll(items);

			// dedupe (kalau mau samain MV tanpa dedupe, biarkan commented)
			// final result = merged
			//     .whereWithIndex((e, index) =>
			//         merged.indexWhere((e2) => e2.asetOthersId == e.asetOthersId) == index)
			//     .toList();

			emit(state.copyWith(
				items: merged, // atau items: result,
				status: ListStatus.success,
				hal: state.hal + 1,
				hasReachedMax: false,
				isFetching: false,
			));

			_recomputeActiveAndFile(emit);
		} catch (_) {
			// kalau error: isFetching false
			if (state.queryKey == keyAtRequest) {
				emit(state.copyWith(status: ListStatus.failure, isFetching: false));
			}
		}
	}


	/*
	Future<void> onFetchAsetothersCari(
			FetchAsetothersCariEvent event,
			Emitter<AsetothersCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		// ✅ guard: kalau lagi loadingMore, jangan spam
		if (state.status == ListStatus.loadingMore) return;

		final repo = AsetothersCariRepository();

		// FIRST LOAD
		if (state.status == ListStatus.initial) {
			final items =
			await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, 0);

			emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));

			_recomputeActiveAndFile(emit);
			return;
		}

		// ✅ next page load: tandai loadingMore tapi JANGAN hapus items
		emit(state.copyWith(status: ListStatus.loadingMore));

		final items =
		await repo.getAsetothersCari(state.cobId, state.statusId, state.searchText, state.hal);

		if (items.isEmpty) {
			emit(state.copyWith(
				hasReachedMax: true,
				status: ListStatus.success, // balik ke success
			));
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
	 */

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
