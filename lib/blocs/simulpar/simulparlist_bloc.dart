import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/simulpar/simulparlist_model.dart';
import 'package:joss_app/repositories/simulpar/simulparlist_repository.dart';

part 'simulparlist_event.dart';
part 'simulparlist_state.dart';

class SimulparListBloc extends Bloc<SimulparListEvents, SimulparListState> {
	SimulparListBloc() : super(const SimulparListState()) {
		on<FetchSimulparListEvent>(onFetchSimulparList);
		on<RefreshSimulparListEvent>(onRefreshSimulparList);
		on<UbahSimulparListEvent>(onUbahSimulparList);
		on<TambahSimulparListEvent>(onTambahSimulparList);
		on<HapusSimulparListEvent>(onHapusSimulparList);
		on<CloseDialogSimulparListEvent>(onCloseDialogSimulparList);
	}

	Future<void> onRefreshSimulparList(
			RefreshSimulparListEvent event, Emitter<SimulparListState> emit) async {
		emit(const SimulparListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchSimulparListEvent());
	}

	Future<void> onFetchSimulparList(
			FetchSimulparListEvent event, Emitter<SimulparListState> emit) async {
		if (state.hasReachedMax) return;

		SimulparListRepository repo = SimulparListRepository();
		if (state.status == ListStatus.initial) {
			List<SimulparListModel> items = await repo.getSimulparList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<SimulparListModel> items = await repo.getSimulparList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<SimulparListModel> simulparList = List.of(state.items)..addAll(items);

			final result = simulparList
				.whereWithIndex((e, index) =>
					simulparList.indexWhere((e2) => e2.simulpar1Id == e.simulpar1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusSimulparList(
		HapusSimulparListEvent event, Emitter<SimulparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogSimulparList(
		CloseDialogSimulparListEvent event, Emitter<SimulparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahSimulparList(
		TambahSimulparListEvent event, Emitter<SimulparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahSimulparList(
		UbahSimulparListEvent event, Emitter<SimulparListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}