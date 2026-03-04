import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/simulmv/simulmvlist_model.dart';
import 'package:joss_app/repositories/simulmv/simulmvlist_repository.dart';

part 'simulmvlist_event.dart';
part 'simulmvlist_state.dart';

class SimulmvListBloc extends Bloc<SimulmvListEvents, SimulmvListState> {
	SimulmvListBloc() : super(const SimulmvListState()) {
		on<FetchSimulmvListEvent>(onFetchSimulmvList);
		on<RefreshSimulmvListEvent>(onRefreshSimulmvList);
		on<UbahSimulmvListEvent>(onUbahSimulmvList);
		on<TambahSimulmvListEvent>(onTambahSimulmvList);
		on<HapusSimulmvListEvent>(onHapusSimulmvList);
		on<CloseDialogSimulmvListEvent>(onCloseDialogSimulmvList);
	}

	Future<void> onRefreshSimulmvList(
			RefreshSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		emit(const SimulmvListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchSimulmvListEvent());
	}

	Future<void> onFetchSimulmvList(
			FetchSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		if (state.hasReachedMax) return;

		SimulmvListRepository repo = SimulmvListRepository();
		if (state.status == ListStatus.initial) {
			List<SimulmvListModel> items = await repo.getSimulmvList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<SimulmvListModel> items = await repo.getSimulmvList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<SimulmvListModel> simulmvList = List.of(state.items)..addAll(items);

			final result = simulmvList
				.whereWithIndex((e, index) =>
					simulmvList.indexWhere((e2) => e2.simulmv1Id == e.simulmv1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusSimulmvList(
		HapusSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogSimulmvList(
		CloseDialogSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahSimulmvList(
		TambahSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahSimulmvList(
		UbahSimulmvListEvent event, Emitter<SimulmvListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}