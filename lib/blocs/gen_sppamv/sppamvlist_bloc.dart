import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_sppamv/sppamvlist_model.dart';
import 'package:joss_app/repositories/gen_sppamv/sppamvlist_repository.dart';

part 'sppamvlist_event.dart';
part 'sppamvlist_state.dart';

class SppamvListBloc extends Bloc<SppamvListEvents, SppamvListState> {
	SppamvListBloc() : super(const SppamvListState()) {
		on<FetchSppamvListEvent>(onFetchSppamvList);
		on<RefreshSppamvListEvent>(onRefreshSppamvList);
		on<UbahSppamvListEvent>(onUbahSppamvList);
		on<TambahSppamvListEvent>(onTambahSppamvList);
		on<HapusSppamvListEvent>(onHapusSppamvList);
		on<CloseDialogSppamvListEvent>(onCloseDialogSppamvList);
	}

	Future<void> onRefreshSppamvList(
			RefreshSppamvListEvent event, Emitter<SppamvListState> emit) async {
		emit(const SppamvListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchSppamvListEvent());
	}

	Future<void> onFetchSppamvList(
			FetchSppamvListEvent event, Emitter<SppamvListState> emit) async {
		if (state.hasReachedMax) return;

		SppamvListRepository repo = SppamvListRepository();
		if (state.status == ListStatus.initial) {
			List<SppamvListModel> items = await repo.getSppamvList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<SppamvListModel> items = await repo.getSppamvList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<SppamvListModel> sppamvList = List.of(state.items)..addAll(items);

			final result = sppamvList
				.whereWithIndex((e, index) =>
					sppamvList.indexWhere((e2) => e2.sppa1Id == e.sppa1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusSppamvList(
		HapusSppamvListEvent event, Emitter<SppamvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogSppamvList(
		CloseDialogSppamvListEvent event, Emitter<SppamvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahSppamvList(
		TambahSppamvListEvent event, Emitter<SppamvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahSppamvList(
		UbahSppamvListEvent event, Emitter<SppamvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}