import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_sppapar/sppaparlist_model.dart';
import 'package:joss_app/repositories/gen_sppapar/sppaparlist_repository.dart';

part 'sppaparlist_event.dart';
part 'sppaparlist_state.dart';

class SppaparListBloc extends Bloc<SppaparListEvents, SppaparListState> {
	SppaparListBloc() : super(const SppaparListState()) {
		on<FetchSppaparListEvent>(onFetchSppaparList);
		on<RefreshSppaparListEvent>(onRefreshSppaparList);
		on<UbahSppaparListEvent>(onUbahSppaparList);
		on<TambahSppaparListEvent>(onTambahSppaparList);
		on<HapusSppaparListEvent>(onHapusSppaparList);
		on<CloseDialogSppaparListEvent>(onCloseDialogSppaparList);
	}

	Future<void> onRefreshSppaparList(
			RefreshSppaparListEvent event, Emitter<SppaparListState> emit) async {
		emit(const SppaparListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchSppaparListEvent());
	}

	Future<void> onFetchSppaparList(
			FetchSppaparListEvent event, Emitter<SppaparListState> emit) async {
		if (state.hasReachedMax) return;

		SppaparListRepository repo = SppaparListRepository();
		if (state.status == ListStatus.initial) {
			List<SppaparListModel> items = await repo.getSppaparList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<SppaparListModel> items = await repo.getSppaparList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<SppaparListModel> sppaparList = List.of(state.items)..addAll(items);

			final result = sppaparList
				.whereWithIndex((e, index) =>
					sppaparList.indexWhere((e2) => e2.sppa1Id == e.sppa1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusSppaparList(
		HapusSppaparListEvent event, Emitter<SppaparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogSppaparList(
		CloseDialogSppaparListEvent event, Emitter<SppaparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahSppaparList(
		TambahSppaparListEvent event, Emitter<SppaparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahSppaparList(
		UbahSppaparListEvent event, Emitter<SppaparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}