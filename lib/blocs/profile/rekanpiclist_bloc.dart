import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/profile/rekanpiclist_model.dart';
import 'package:joss_app/repositories/profile/rekanpiclist_repository.dart';

part 'rekanpiclist_event.dart';
part 'rekanpiclist_state.dart';

class RekanPicListBloc extends Bloc<RekanPicListEvents, RekanPicListState> {
	RekanPicListBloc() : super(const RekanPicListState()) {
		on<FetchRekanPicListEvent>(onFetchRekanPicList);
		on<RefreshRekanPicListEvent>(onRefreshRekanPicList);
		on<UbahRekanPicListEvent>(onUbahRekanPicList);
		on<TambahRekanPicListEvent>(onTambahRekanPicList);
		on<HapusRekanPicListEvent>(onHapusRekanPicList);
		on<CloseDialogRekanPicListEvent>(onCloseDialogRekanPicList);
	}

	Future<void> onRefreshRekanPicList(
			RefreshRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		emit(const RekanPicListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchRekanPicListEvent());
	}

	Future<void> onFetchRekanPicList(
			FetchRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		if (state.hasReachedMax) return;

		RekanPicListRepository repo = RekanPicListRepository();
		if (state.status == ListStatus.initial) {
			List<RekanPicListModel> items = await repo.getRekanPicList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<RekanPicListModel> items = await repo.getRekanPicList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<RekanPicListModel> rekanPicList = List.of(state.items)..addAll(items);

			final result = rekanPicList
				.whereWithIndex((e, index) =>
					rekanPicList.indexWhere((e2) => e2.mrekanpicId == e.mrekanpicId) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusRekanPicList(
		HapusRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogRekanPicList(
		CloseDialogRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahRekanPicList(
		TambahRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahRekanPicList(
		UbahRekanPicListEvent event, Emitter<RekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}