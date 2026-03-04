import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/klaim/klaim1list_model.dart';
import 'package:joss_app/repositories/klaim/klaim1list_repository.dart';

part 'klaim1list_event.dart';
part 'klaim1list_state.dart';

class Klaim1ListBloc extends Bloc<Klaim1ListEvents, Klaim1ListState> {
	Klaim1ListBloc() : super(const Klaim1ListState()) {
		on<FetchKlaim1ListEvent>(onFetchKlaim1List);
		on<RefreshKlaim1ListEvent>(onRefreshKlaim1List);
		on<TrackKlaim1ListEvent>(onTrackKlaim1List);
		on<TambahKlaim1ListEvent>(onTambahKlaim1List);
		on<HapusKlaim1ListEvent>(onHapusKlaim1List);
		on<CloseDialogKlaim1ListEvent>(onCloseDialogKlaim1List);
	}

	Future<void> onRefreshKlaim1List(
			RefreshKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		emit(const Klaim1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchKlaim1ListEvent());
	}

	Future<void> onFetchKlaim1List(
			FetchKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		if (state.hasReachedMax) return;

		Klaim1ListRepository repo = Klaim1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Klaim1ListModel> items = await repo.getKlaim1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Klaim1ListModel> items = await repo.getKlaim1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Klaim1ListModel> klaim1List = List.of(state.items)..addAll(items);

			final result = klaim1List
				.whereWithIndex((e, index) =>
					klaim1List.indexWhere((e2) => e2.klaim1Id == e.klaim1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusKlaim1List(
		HapusKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogKlaim1List(
		CloseDialogKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahKlaim1List(
		TambahKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onTrackKlaim1List(
		TrackKlaim1ListEvent event, Emitter<Klaim1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "track", recordId: event.klaim1Id));
	}

}