import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekancontactlist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactlist_repository.dart';

part 'mrekancontactlist_event.dart';
part 'mrekancontactlist_state.dart';

class MRekanContactListBloc extends Bloc<MRekanContactListEvents, MRekanContactListState> {
	MRekanContactListBloc() : super(const MRekanContactListState()) {
		on<FetchMRekanContactListEvent>(onFetchMRekanContactList);
		on<RefreshMRekanContactListEvent>(onRefreshMRekanContactList);
		on<UbahMRekanContactListEvent>(onUbahMRekanContactList);
		on<TambahMRekanContactListEvent>(onTambahMRekanContactList);
		on<HapusMRekanContactListEvent>(onHapusMRekanContactList);
		on<CloseDialogMRekanContactListEvent>(onCloseDialogMRekanContactList);
	}

	Future<void> onRefreshMRekanContactList(
			RefreshMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		emit(const MRekanContactListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekanContactListEvent());
	}

	Future<void> onFetchMRekanContactList(
			FetchMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanContactListRepository repo = MRekanContactListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanContactListModel> items = await repo.getMRekanContactList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekanContactListModel> items = await repo.getMRekanContactList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanContactListModel> mRekanContactList = List.of(state.items)..addAll(items);

			final result = mRekanContactList
				.whereWithIndex((e, index) =>
					mRekanContactList.indexWhere((e2) => e2.mrekancontact1Id == e.mrekancontact1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekanContactList(
		HapusMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanContactList(
		CloseDialogMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanContactList(
		TambahMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanContactList(
		UbahMRekanContactListEvent event, Emitter<MRekanContactListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}