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
	}

	// 🔁 Normal Refresh
	Future<void> onRefreshAsetMvCari(
			RefreshAsetMvCariEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		emit(const AsetMvCariState());

		emit(state.copyWith(
			status: ListStatus.initial,
			items: const <AsetMvCariModel>[],
			hasReachedMax: false,
			hal: 0,
			searchText: event.searchText,
			statusId: event.statusId,
		));

		add(FetchAsetMvCariEvent());
	}

	// 📦 Normal Fetch (memperbarui tabel)
	Future<void> onFetchAsetMvCari(
			FetchAsetMvCariEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetMvCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetMvCari(state.statusId, state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));
		}

		final items = await repo.getAsetMvCari(state.statusId, state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			final asetMvCari = List.of(state.items)..addAll(items);

			final result = asetMvCari
					.whereWithIndex((e, index) =>
			asetMvCari.indexWhere((e2) => e2.asetMvId == e.asetMvId) == index)
					.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
			));
		}
	}

	// 🧠 Debug Fetch (tidak trigger rebuild tabel)
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
				debugPrint("➡️ ${i.jenisMv} | Merk: ${i.merk} | Polis: ${i.polisNo} | Status: ${i.status}");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error: $e");
			debugPrint(stack.toString());
		}
	}

	Future<void> onSelectDetail(
			SelectMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..add(event.asetMvId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onUnselectDetail(
			UnselectMvDetailEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..remove(event.asetMvId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onClearSelection(
			ClearMvSelectionEvent event,
			Emitter<AsetMvCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;
		emit(state.copyWith(selectedIds: <String>{}));
	}
}
