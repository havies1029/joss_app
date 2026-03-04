import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_klaim/klaim2list_model.dart';
import 'package:joss_app/repositories/gen_klaim/klaim2list_repository.dart';

part 'klaim2list_event.dart';
part 'klaim2list_state.dart';

class Klaim2ListBloc extends Bloc<Klaim2ListEvents, Klaim2ListState> {
	Klaim2ListBloc() : super(const Klaim2ListState()) {
		on<FetchKlaim2ListEvent>(onFetchKlaim2List);
		on<RefreshKlaim2ListEvent>(onRefreshKlaim2List);
		on<UbahKlaim2ListEvent>(onUbahKlaim2List);
		on<TambahKlaim2ListEvent>(onTambahKlaim2List);
		on<HapusKlaim2ListEvent>(onHapusKlaim2List);
		on<CloseDialogKlaim2ListEvent>(onCloseDialogKlaim2List);
	}

	Future<void> onRefreshKlaim2List(
			RefreshKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		emit(const Klaim2ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchKlaim2ListEvent());
	}

	Future<void> onFetchKlaim2List(
			FetchKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		if (state.hasReachedMax) return;

		Klaim2ListRepository repo = Klaim2ListRepository();
		if (state.status == ListStatus.initial) {
			List<Klaim2ListModel> items = await repo.getKlaim2List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Klaim2ListModel> items = await repo.getKlaim2List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Klaim2ListModel> klaim2List = List.of(state.items)..addAll(items);

			final result = klaim2List
				.whereWithIndex((e, index) =>
					klaim2List.indexWhere((e2) => e2.klaim2Id == e.klaim2Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusKlaim2List(
		HapusKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogKlaim2List(
		CloseDialogKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahKlaim2List(
		TambahKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahKlaim2List(
		UbahKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}