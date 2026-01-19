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
	}

	Future<void> onRefreshAsetParCari(
			RefreshAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		emit(AsetParCariState(
			items: const [],
			status: ListStatus.initial,
			hal: 0,
			searchText: event.searchText,
			statusId: event.statusId,
			hasReachedMax: false,
		));

		emit(state.copyWith(
			searchText: event.searchText,
			hal: 0,
			statusId: event.statusId,
		));

		add(FetchAsetParCariEvent());
	}

	// 📦 Fetch normal (update UI)
	Future<void> onFetchAsetParCari(
			FetchAsetParCariEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		final repo = AsetParCariRepository();

		if (state.status == ListStatus.initial) {
			final items = await repo.getAsetParCari(state.statusId, state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1,
			));
		}

		final items = await repo.getAsetParCari(state.statusId, state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			final asetParCari = List.of(state.items)..addAll(items);

			final result = asetParCari
					.whereWithIndex((e, index) =>
			asetParCari.indexWhere((e2) => e2.asetParId == e.asetParId) == index)
					.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1,
			));
		}
	}

	// 🧠 Debug Fetch (tidak ubah UI, hanya tampil di console)
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
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..add(event.asetParId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onUnselectDetail(
			UnselectDetailEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		final updatedSelectedIds = Set<String>.from(state.selectedIds)
			..remove(event.asetParId);

		emit(state.copyWith(selectedIds: updatedSelectedIds));
	}

	Future<void> onClearSelection(
			ClearParSelectionEvent event,
			Emitter<AsetParCariState> emit,
			) async {
		if (state.selectedIds.isEmpty) return;
		emit(state.copyWith(selectedIds: <String>{}));
	}

}
