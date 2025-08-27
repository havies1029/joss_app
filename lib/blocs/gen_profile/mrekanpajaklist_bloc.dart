import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekanpajaklist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpajaklist_repository.dart';

part 'mrekanpajaklist_event.dart';
part 'mrekanpajaklist_state.dart';

class MRekanPajakListBloc extends Bloc<MRekanPajakListEvents, MRekanPajakListState> {
	MRekanPajakListBloc() : super(const MRekanPajakListState()) {
		on<FetchMRekanPajakListEvent>(onFetchMRekanPajakList);
		on<RefreshMRekanPajakListEvent>(onRefreshMRekanPajakList);
		on<UbahMRekanPajakListEvent>(onUbahMRekanPajakList);
		on<TambahMRekanPajakListEvent>(onTambahMRekanPajakList);
		on<HapusMRekanPajakListEvent>(onHapusMRekanPajakList);
		on<CloseDialogMRekanPajakListEvent>(onCloseDialogMRekanPajakList);
	}

	Future<void> onRefreshMRekanPajakList(
			RefreshMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		emit(const MRekanPajakListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekanPajakListEvent());
	}

	Future<void> onFetchMRekanPajakList(
			FetchMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanPajakListRepository repo = MRekanPajakListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanPajakListModel> items = await repo.getMRekanPajakList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekanPajakListModel> items = await repo.getMRekanPajakList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanPajakListModel> mRekanPajakList = List.of(state.items)..addAll(items);

			final result = mRekanPajakList
				.whereWithIndex((e, index) =>
					mRekanPajakList.indexWhere((e2) => e2.mrekanpajakId == e.mrekanpajakId) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekanPajakList(
		HapusMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanPajakList(
		CloseDialogMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanPajakList(
		TambahMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanPajakList(
		UbahMRekanPajakListEvent event, Emitter<MRekanPajakListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}