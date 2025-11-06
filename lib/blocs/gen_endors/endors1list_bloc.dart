import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_endors/endors1list_model.dart';
import 'package:joss_app/repositories/gen_endors/endors1list_repository.dart';

part 'endors1list_event.dart';
part 'endors1list_state.dart';

class Endors1ListBloc extends Bloc<Endors1ListEvents, Endors1ListState> {
	Endors1ListBloc() : super(const Endors1ListState()) {
		on<FetchEndors1ListEvent>(onFetchEndors1List);
		on<RefreshEndors1ListEvent>(onRefreshEndors1List);
		on<UbahEndors1ListEvent>(onUbahEndors1List);
		on<TambahEndors1ListEvent>(onTambahEndors1List);
		on<HapusEndors1ListEvent>(onHapusEndors1List);
		on<CloseDialogEndors1ListEvent>(onCloseDialogEndors1List);
	}

	// 🔁 Event: Refresh Data
	Future<void> onRefreshEndors1List(
			RefreshEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("🔄 [Bloc] RefreshEndors1ListEvent(search='${event.searchText}', hal=${event.hal})");

		// ⚠️ Jangan reset full state pakai const (itu menghapus semua nilai)
		emit(state.copyWith(searchText: event.searchText, hal: 0, hasReachedMax: false));
		debugPrint("📥 [Bloc] searchText diset ke '${state.searchText}'");

		add(FetchEndors1ListEvent());
	}

	// 📦 Event: Ambil data dari repository
	Future<void> onFetchEndors1List(
			FetchEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("📡 [Bloc] FetchEndors1ListEvent(searchText='${state.searchText}', hal=${state.hal})");

		if (state.hasReachedMax) {
			debugPrint("⛔ [Bloc] hasReachedMax = true, hentikan fetch berikutnya.");
			return;
		}

		final repo = Endors1ListRepository();

		try {
			if (state.status == ListStatus.initial) {
				debugPrint("🚀 [Bloc] Status initial → ambil halaman pertama.");
				final items = await repo.getEndors1List(state.searchText, 0);

				debugPrint("📦 [Bloc] Repository kembalikan ${items.length} data.");
				for (final i in items) {
					debugPrint("➡️ [Bloc] ${i.endors1Id} | ${i.insuredNama} | ${i.statusEndors}");
				}

				emit(state.copyWith(
					items: items,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: 1,
				));
				debugPrint("✅ [Bloc] Emit success pertama (${items.length} items, hal=1)");
			} else {
				debugPrint("🔁 [Bloc] Status success → ambil data halaman ke-${state.hal}");
				final items = await repo.getEndors1List(state.searchText, state.hal);

				if (items.isEmpty) {
					debugPrint("⚠️ [Bloc] Tidak ada data baru, set hasReachedMax=true");
					emit(state.copyWith(hasReachedMax: true));
				} else {
					debugPrint("📈 [Bloc] Dapat tambahan ${items.length} data");
					final allItems = List.of(state.items)..addAll(items);

					final result = allItems
							.whereWithIndex((e, index) =>
					allItems.indexWhere((e2) => e2.endors1Id == e.endors1Id) == index)
							.toList();

					emit(state.copyWith(
						items: result,
						hasReachedMax: false,
						status: ListStatus.success,
						hal: state.hal + 1,
					));

					debugPrint("✅ [Bloc] Emit success (total ${result.length} data, hal=${state.hal + 1})");
				}
			}
		} catch (e, st) {
			debugPrint("💥 [Bloc] Error saat Fetch: $e");
			debugPrint(st.toString());
			emit(state.copyWith(status: ListStatus.failure));
		}
	}

	// 🗑️ Event: Hapus
	Future<void> onHapusEndors1List(
			HapusEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("🗑️ [Bloc] Event HapusEndors1ListEvent");
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	// 🔙 Event: Tutup dialog
	Future<void> onCloseDialogEndors1List(
			CloseDialogEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("🔙 [Bloc] Event CloseDialogEndors1ListEvent");
		emit(state.copyWith(viewMode: ""));
	}

	// ➕ Event: Tambah data
	Future<void> onTambahEndors1List(
			TambahEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("➕ [Bloc] Event TambahEndors1ListEvent");
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	// ✏️ Event: Ubah data
	Future<void> onUbahEndors1List(
			UbahEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		debugPrint("✏️ [Bloc] Event UbahEndors1ListEvent(recordId=${event.recordId})");
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}
}
