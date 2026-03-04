import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_dn1/dn1cari_model.dart';
import 'package:joss_app/repositories/gen_dn1/dn1cari_repository.dart';

part 'dn1cari_event.dart';
part 'dn1cari_state.dart';

class Dn1CariBloc extends Bloc<Dn1CariEvents, Dn1CariState> {
	Dn1CariBloc() : super(const Dn1CariState()) {
		on<FetchDn1CariEvent>(onFetchDn1Cari);
		on<RefreshDn1CariEvent>(onRefreshDn1Cari);
	}

	// 🧭 EVENT: Refresh
	Future<void> onRefreshDn1Cari(
			RefreshDn1CariEvent event, Emitter<Dn1CariState> emit) async {
		print("🌀 [RefreshDn1CariEvent] triggered for sppa1Id=${event.sppa1Id}");

		// Reset state ke default (kosong)
		emit(const Dn1CariState());

		// Simpan sppa1Id di state
		emit(state.copyWith(sppa1Id: event.sppa1Id));
		print("✅ State updated with new sppa1Id=${state.sppa1Id}");

		// Fetch ulang data
		add(FetchDn1CariEvent());
	}

	// 🧭 EVENT: Fetch
	Future<void> onFetchDn1Cari(
			FetchDn1CariEvent event, Emitter<Dn1CariState> emit) async {
		if (state.hasReachedMax) {
			print("⚠️ [FetchDn1CariEvent] hasReachedMax=true → skip fetch");
			return;
		}

		Dn1CariRepository repo = Dn1CariRepository();
		print("🚀 [FetchDn1CariEvent] fetching data for sppa1Id=${state.sppa1Id}");

		try {
			// === Initial Fetch ===
			if (state.status == ListStatus.initial) {
				final items = await repo.getDn1Cari(state.sppa1Id);
				print("📦 Initial fetch success → ${items.length} items retrieved");
				if (items.isEmpty) {
					print("❌ No data found for sppa1Id=${state.sppa1Id}");
				} else {
					print("✅ Data sample: ${items.first.toJson()}");
				}

				return emit(state.copyWith(
					items: items,
					hasReachedMax: false,
					status: ListStatus.success,
				));
			}

			// === Pagination Fetch ===
			final items = await repo.getDn1Cari(state.sppa1Id);
			print("📩 Pagination fetch → ${items.length} items retrieved");

			if (items.isEmpty) {
				print("🛑 No more data → setting hasReachedMax=true");
				return emit(state.copyWith(hasReachedMax: true));
			} else {
				final dn1Cari = List.of(state.items)..addAll(items);

				final result = dn1Cari
						.whereWithIndex((e, index) =>
				dn1Cari.indexWhere((e2) => e2.dn1Id == e.dn1Id) == index)
						.toList();

				print("🧮 Total unique items after merge: ${result.length}");

				return emit(state.copyWith(
					items: result,
					hasReachedMax: false,
					status: ListStatus.success,
				));
			}
		} catch (e, stack) {
			print("💥 ERROR during fetch: $e");
			print(stack);
		}
	}
}
