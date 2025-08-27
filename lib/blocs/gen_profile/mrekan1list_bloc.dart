import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekan1list_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekan1list_repository.dart';

part 'mrekan1list_event.dart';
part 'mrekan1list_state.dart';

class MRekan1ListBloc extends Bloc<MRekan1ListEvents, MRekan1ListState> {
	MRekan1ListBloc() : super(const MRekan1ListState()) {
		on<FetchMRekan1ListEvent>(onFetchMRekan1List);
		on<RefreshMRekan1ListEvent>(onRefreshMRekan1List);
		on<UbahMRekan1ListEvent>(onUbahMRekan1List);
		on<TambahMRekan1ListEvent>(onTambahMRekan1List);
		on<HapusMRekan1ListEvent>(onHapusMRekan1List);
		on<CloseDialogMRekan1ListEvent>(onCloseDialogMRekan1List);
	}

	Future<void> onRefreshMRekan1List(
			RefreshMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		emit(const MRekan1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMRekan1ListEvent());
	}

	Future<void> onFetchMRekan1List(
			FetchMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		if (state.hasReachedMax) return;

		MRekan1ListRepository repo = MRekan1ListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekan1ListModel> items = await repo.getMRekan1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MRekan1ListModel> items = await repo.getMRekan1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekan1ListModel> mRekan1List = List.of(state.items)..addAll(items);

			final result = mRekan1List
				.whereWithIndex((e, index) =>
					mRekan1List.indexWhere((e2) => e2.mrekan1Id == e.mrekan1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMRekan1List(
		HapusMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekan1List(
		CloseDialogMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekan1List(
		TambahMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekan1List(
		UbahMRekan1ListEvent event, Emitter<MRekan1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}