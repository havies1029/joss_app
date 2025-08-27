import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvlist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekangeneralidvlist_repository.dart';

part 'mrekangeneralidvlist_event.dart';
part 'mrekangeneralidvlist_state.dart';

class MRekanGeneralIdvListBloc extends Bloc<MRekanGeneralIdvListEvents, MRekanGeneralIdvListState> {
	MRekanGeneralIdvListBloc() : super(const MRekanGeneralIdvListState()) {
		on<FetchMRekanGeneralIdvListEvent>(onFetchMRekanGeneralIdvList);
		on<RefreshMRekanGeneralIdvListEvent>(onRefreshMRekanGeneralIdvList);
		on<UbahMRekanGeneralIdvListEvent>(onUbahMRekanGeneralIdvList);
		on<TambahMRekanGeneralIdvListEvent>(onTambahMRekanGeneralIdvList);
		on<HapusMRekanGeneralIdvListEvent>(onHapusMRekanGeneralIdvList);
		on<CloseDialogMRekanGeneralIdvListEvent>(onCloseDialogMRekanGeneralIdvList);
	}

	Future<void> onRefreshMRekanGeneralIdvList(
			RefreshMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		emit(const MRekanGeneralIdvListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekanGeneralIdvListEvent());
	}

	Future<void> onFetchMRekanGeneralIdvList(
			FetchMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanGeneralIdvListRepository repo = MRekanGeneralIdvListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanGeneralIdvListModel> items = await repo.getMRekanGeneralIdvList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekanGeneralIdvListModel> items = await repo.getMRekanGeneralIdvList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanGeneralIdvListModel> mRekanGeneralIdvList = List.of(state.items)..addAll(items);

			final result = mRekanGeneralIdvList
				.whereWithIndex((e, index) =>
					mRekanGeneralIdvList.indexWhere((e2) => e2.mrekan1Id == e.mrekan1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekanGeneralIdvList(
		HapusMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanGeneralIdvList(
		CloseDialogMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanGeneralIdvList(
		TambahMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanGeneralIdvList(
		UbahMRekanGeneralIdvListEvent event, Emitter<MRekanGeneralIdvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}