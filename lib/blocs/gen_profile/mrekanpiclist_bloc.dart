import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekanpiclist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';

part 'mrekanpiclist_event.dart';
part 'mrekanpiclist_state.dart';

class MRekanPicListBloc extends Bloc<MRekanPicListEvents, MRekanPicListState> {
	MRekanPicListBloc() : super(const MRekanPicListState()) {
		on<FetchMRekanPicListEvent>(onFetchMRekanPicList);
		on<RefreshMRekanPicListEvent>(onRefreshMRekanPicList);
		on<UbahMRekanPicListEvent>(onUbahMRekanPicList);
		on<TambahMRekanPicListEvent>(onTambahMRekanPicList);
		on<HapusMRekanPicListEvent>(onHapusMRekanPicList);
		on<CloseDialogMRekanPicListEvent>(onCloseDialogMRekanPicList);
	}

	Future<void> onRefreshMRekanPicList(
			RefreshMRekanPicListEvent event,
			Emitter<MRekanPicListState> emit,
			) async {
		try {
			emit(const MRekanPicListState());

			final repo = MRekanPicListRepository();
			final items = await repo.getMRekanPicList();

			emit(state.copyWith(
				items: items,
				status: ListStatus.success,
				hasReachedMax: true,
				hal: 1,
			));
		} catch (e) {
			emit(state.copyWith(status: ListStatus.failure));
		}
	}

	Future<void> onFetchMRekanPicList(
			FetchMRekanPicListEvent event,
			Emitter<MRekanPicListState> emit,
			) async {
		try {
			emit(state.copyWith(status: ListStatus.initial));

			final repo = MRekanPicListRepository();
			final items = await repo.getMRekanPicList();

			emit(state.copyWith(
				items: items,
				status: ListStatus.success,
				hasReachedMax: true,
				hal: 1,
			));
		} catch (e) {
			emit(state.copyWith(
				status: ListStatus.failure,
			));
		}
	}

	Future<void> onHapusMRekanPicList(
			HapusMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMRekanPicList(
			CloseDialogMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMRekanPicList(
			TambahMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMRekanPicList(
			UbahMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}