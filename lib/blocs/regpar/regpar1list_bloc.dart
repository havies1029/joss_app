import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regpar/regpar1list_model.dart';
import 'package:joss_app/repositories/regpar/regpar1list_repository.dart';

part 'regpar1list_event.dart';
part 'regpar1list_state.dart';

class Regpar1ListBloc extends Bloc<Regpar1ListEvents, Regpar1ListState> {
	Regpar1ListBloc() : super(const Regpar1ListState()) {
		on<FetchRegpar1ListEvent>(onFetchRegpar1List);
		on<RefreshRegpar1ListEvent>(onRefreshRegpar1List);
		on<UbahRegpar1ListEvent>(onUbahRegpar1List);
		on<TambahRegpar1ListEvent>(onTambahRegpar1List);
		on<HapusRegpar1ListEvent>(onHapusRegpar1List);
		on<CloseDialogRegpar1ListEvent>(onCloseDialogRegpar1List);
	}

	Future<void> onRefreshRegpar1List(
			RefreshRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		emit(const Regpar1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchRegpar1ListEvent());
	}

	Future<void> onFetchRegpar1List(
			FetchRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		if (state.hasReachedMax) return;

		Regpar1ListRepository repo = Regpar1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Regpar1ListModel> items = await repo.getRegpar1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Regpar1ListModel> items = await repo.getRegpar1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Regpar1ListModel> regpar1List = List.of(state.items)..addAll(items);

			final result = regpar1List
				.whereWithIndex((e, index) =>
					regpar1List.indexWhere((e2) => e2.regpar1Id == e.regpar1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusRegpar1List(
		HapusRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogRegpar1List(
		CloseDialogRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahRegpar1List(
		TambahRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahRegpar1List(
		UbahRegpar1ListEvent event, Emitter<Regpar1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}