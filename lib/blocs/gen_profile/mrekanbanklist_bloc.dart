import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekanbanklist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbanklist_repository.dart';

part 'mrekanbanklist_event.dart';
part 'mrekanbanklist_state.dart';

class MRekanBankListBloc extends Bloc<MRekanBankListEvents, MRekanBankListState> {
	MRekanBankListBloc() : super(const MRekanBankListState()) {
		on<FetchMRekanBankListEvent>(onFetchMRekanBankList);
		on<RefreshMRekanBankListEvent>(onRefreshMRekanBankList);
		on<UbahMRekanBankListEvent>(onUbahMRekanBankList);
		on<TambahMRekanBankListEvent>(onTambahMRekanBankList);
		on<HapusMRekanBankListEvent>(onHapusMRekanBankList);
		on<CloseDialogMRekanBankListEvent>(onCloseDialogMRekanBankList);
	}

	Future<void> onRefreshMRekanBankList(
			RefreshMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		emit(const MRekanBankListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekanBankListEvent());
	}

	Future<void> onFetchMRekanBankList(
			FetchMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanBankListRepository repo = MRekanBankListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanBankListModel> items = await repo.getMRekanBankList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekanBankListModel> items = await repo.getMRekanBankList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanBankListModel> mRekanBankList = List.of(state.items)..addAll(items);

			final result = mRekanBankList
				.whereWithIndex((e, index) =>
					mRekanBankList.indexWhere((e2) => e2.mrekanbankId == e.mrekanbankId) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekanBankList(
		HapusMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanBankList(
		CloseDialogMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanBankList(
		TambahMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanBankList(
		UbahMRekanBankListEvent event, Emitter<MRekanBankListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}