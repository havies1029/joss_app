import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_aset_hull/asethullcari_model.dart';
import 'package:joss_app/repositories/gen_aset_hull/asethullcari_repository.dart';

part 'asethullcari_event.dart';
part 'asethullcari_state.dart';

class AsethullCariBloc extends Bloc<AsethullCariEvents, AsethullCariState> {
	AsethullCariBloc() : super(const AsethullCariState()) {
		on<FetchAsethullCariEvent>(onFetchAsethullCari);
		on<RefreshAsethullCariEvent>(onRefreshAsethullCari);
		on<DebugFetchAsethullCariEvent>(_onDebugFetchAsethullCari);
	}

Future<void> onRefreshAsethullCari(
		RefreshAsethullCariEvent event, Emitter<AsethullCariState> emit) async {
	emit(const AsethullCariState());
  
  emit(state.copyWith(statusId: event.statusId, searchText: event.searchText));

	add(FetchAsethullCariEvent());
}

Future<void> onFetchAsethullCari(
		FetchAsethullCariEvent event, Emitter<AsethullCariState> emit) async {
	if (state.hasReachedMax) return;

	AsethullCariRepository repo = AsethullCariRepository();
	if (state.status == ListStatus.initial) {
		List<AsethullCariModel> items = await repo.getAsethullCari(state.statusId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1
			));
	}
	List<AsethullCariModel> items = await repo.getAsethullCari(state.statusId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<AsethullCariModel> asethullCari = List.of(state.items)..addAll(items);

		final result = asethullCari
			.whereWithIndex((e, index) =>
				asethullCari.indexWhere((e2) => e2.asetHullId == e.asetHullId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1
			));
		}

	}

	Future<void> _onDebugFetchAsethullCari(
			DebugFetchAsethullCariEvent event,
			Emitter<AsethullCariState> emit,
			) async {
		final repo = AsethullCariRepository();

		debugPrint("🚢 [DebugFetch] Mulai ambil data Hull untuk '${event.searchText}'...");

		try {
			final results = await repo.getAsethullCari(
				event.statusId,
				event.searchText,
				0, // offset awal
			);

			debugPrint("✅ [DebugFetch] ${results.length} hasil ditemukan untuk '${event.searchText}'");
			for (final i in results) {
				debugPrint("⚓ Nama Kapal: ${i.namaKapal} | Polis: ${i.polisNo} | Curr: ${i.curr} | "
						"Premi: ${i.premi} | TSI: ${i.tsi} | Status: ${i.status}");
			}
			debugPrint("-----------------------------------------------------");
		} catch (e, stack) {
			debugPrint("💥 [DebugFetch] Error saat ambil data Hull: $e");
			debugPrint(stack.toString());
		}
	}

}