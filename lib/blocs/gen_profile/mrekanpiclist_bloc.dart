import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/mrekanpiclist_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanpiclist_repository.dart';

part 'mrekanpiclist_event.dart';
part 'mrekanpiclist_state.dart';

class MRekanPicListBloc extends Bloc<MRekanPicListEvents, MRekanPicListState> {
	final MRekanPicListRepository repository;

	MRekanPicListBloc({required this.repository}) : super(const MRekanPicListState()) {
		on<FetchMRekanPicListEvent>((event, emit) async {
			emit(state.copyWith(
				// status: ListStatus.loading,
				items: [],
				hasReachedMax: false,
			));

			try {
				final newItems = await repository.getMRekanPicList();

				emit(state.copyWith(
					status: ListStatus.success,
					items: newItems,
				));
			} catch (e) {
				emit(state.copyWith(status: ListStatus.failure));
			}
		});

		on<RefreshMRekanPicListEvent>(onRefreshMRekanPicList);
		on<UbahMRekanPicListEvent>(onUbahMRekanPicList);
		on<TambahMRekanPicListEvent>(onTambahMRekanPicList);
		on<HapusMRekanPicListEvent>(onHapusMRekanPicList);
		on<CloseDialogMRekanPicListEvent>(onCloseDialogMRekanPicList);
	}

	Future<void> onRefreshMRekanPicList(
			RefreshMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		emit(const MRekanPicListState());
		add(FetchMRekanPicListEvent());
	}

	Future<void> onFetchMRekanPicList(
			FetchMRekanPicListEvent event, Emitter<MRekanPicListState> emit) async {
		if (state.hasReachedMax) return;

		MRekanPicListRepository repo = MRekanPicListRepository();
		if (state.status == ListStatus.initial) {
			List<MRekanPicListModel> items = await repo.getMRekanPicList();
			return emit(state.copyWith(
					items: items,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: 1));
		}
		List<MRekanPicListModel> items = await repo.getMRekanPicList();
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MRekanPicListModel> mRekanPicList = List.of(state.items)..addAll(items);

			final result = mRekanPicList
					.whereWithIndex((e, index) =>
			mRekanPicList.indexWhere((e2) => e2.mrekanpicId == e.mrekanpicId) ==
					index)
					.toList();

			return emit(state.copyWith(
					items: result,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: state.hal + 1));
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