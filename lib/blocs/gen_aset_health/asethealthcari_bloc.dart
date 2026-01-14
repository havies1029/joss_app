import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';
import 'package:joss_app/repositories/gen_aset_health/asethealthcari_repository.dart';

part 'asethealthcari_event.dart';
part 'asethealthcari_state.dart';

class AsetHealthCariBloc extends Bloc<AsetHealthCariEvents, AsetHealthCariState> {
	AsetHealthCariBloc() : super(const AsetHealthCariState()) {
		on<FetchAsetHealthCariEvent>(onFetchAsetHealthCari);
		on<RefreshAsetHealthCariEvent>(onRefreshAsetHealthCari);
		on<DebugFetchAsetHealthCariEvent>(_onDebugFetchAsetHealthCari);
		on<SelectHealthDetailEvent>(onSelectDetail);
		on<UnselectHealthDetailEvent>(onUnselectDetail);
		on<ClearHealthSelectionEvent>(onClearSelection);
	}

	// 🔁 Normal Refresh (memperbarui tabel)
	Future<void> onRefreshAsetHealthCari(
			RefreshAsetHealthCariEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		emit(const AsetHealthCariState());
		emit(state.copyWith(statusId: event.statusId, searchText: event.searchText));
		add(FetchAsetHealthCariEvent());
	}

	// 📦 Normal Fetch (memperbarui state)
	Future<void> onFetchAsetHealthCari(
			FetchAsetHealthCariEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetHealthCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetHealthCari(
				state.statusId,
				state.searchText,
				0,
			);

			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));
		}

		final items = await repo.getAsetHealthCari(
			state.statusId,
			state.searchText,
			state.hal,
		);

		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			final asetHealthCari = List.of(state.items)..addAll(items);

			final result = asetHealthCari
					.whereWithIndex(
						(e, index) =>
				asetHealthCari.indexWhere(
								(e2) => e2.asethealthId == e.asethealthId) ==
						index,
			)
					.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
			));
		}
	}


	// 🧠 Debug Fetch (tidak mengubah state UI)
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
				debugPrint("➡️ ${i.nama} | Polis: ${i.polisNo} | Status: ${i.status}");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error: $e");
			debugPrint(stack.toString());
		}
	}

	Future<void> onSelectDetail(
			SelectHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..add(event.asethealthId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onUnselectDetail(
			UnselectHealthDetailEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..remove(event.asethealthId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onClearSelection(
			ClearHealthSelectionEvent event,
			Emitter<AsetHealthCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;
		emit(state.copyWith(selectedIds: <String>{}));
	}
}
