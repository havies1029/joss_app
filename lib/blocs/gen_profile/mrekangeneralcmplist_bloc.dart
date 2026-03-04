import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmplist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralcmplist_repository.dart';

part 'mrekangeneralcmplist_event.dart';
part 'mrekangeneralcmplist_state.dart';

class MRekanGeneralCmpListBloc extends Bloc<MRekanGeneralCmpListEvents, MRekanGeneralCmpListState> {
	MRekanGeneralCmpListBloc() : super(const MRekanGeneralCmpListState()) {
		on<FetchMRekanGeneralCmpListEvent>(onFetchMRekanGeneralCmpList);
		on<RefreshMRekanGeneralCmpListEvent>(onRefreshMRekanGeneralCmpList);
		on<UbahMRekanGeneralCmpListEvent>(onUbahMRekanGeneralCmpList);
		on<TambahMRekanGeneralCmpListEvent>(onTambahMRekanGeneralCmpList);
		on<HapusMRekanGeneralCmpListEvent>(onHapusMRekanGeneralCmpList);
		on<CloseDialogMRekanGeneralCmpListEvent>(onCloseDialogMRekanGeneralCmpList);
	}

	Future<void> onRefreshMRekanGeneralCmpList(
			RefreshMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		emit(const MRekanGeneralCmpListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekanGeneralCmpListEvent());
	}

	Future<void> onFetchMRekanGeneralCmpList(
			FetchMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanGeneralCmpListRepository repo = MRekanGeneralCmpListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanGeneralCmpListModel> items = await repo.getMRekanGeneralCmpList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekanGeneralCmpListModel> items = await repo.getMRekanGeneralCmpList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanGeneralCmpListModel> mRekanGeneralCmpList = List.of(state.items)..addAll(items);

			final result = mRekanGeneralCmpList
				.whereWithIndex((e, index) =>
					mRekanGeneralCmpList.indexWhere((e2) => e2.mrekan1Id == e.mrekan1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekanGeneralCmpList(
		HapusMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanGeneralCmpList(
		CloseDialogMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanGeneralCmpList(
		TambahMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanGeneralCmpList(
		UbahMRekanGeneralCmpListEvent event, Emitter<MRekanGeneralCmpListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}