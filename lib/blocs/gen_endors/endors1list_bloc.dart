import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_endors/endors1list_model.dart';
import 'package:joss_app/repositories/gen_endors/endors1list_repository.dart';

part 'endors1list_event.dart';
part 'endors1list_state.dart';

class Endors1ListBloc extends Bloc<Endors1ListEvents, Endors1ListState> {
	Endors1ListBloc() : super(const Endors1ListState()) {
		on<FetchEndors1ListEvent>(onFetchEndors1List);
		on<RefreshEndors1ListEvent>(onRefreshEndors1List);
		on<UbahEndors1ListEvent>(onUbahEndors1List);
		on<TambahEndors1ListEvent>(onTambahEndors1List);
		on<HapusEndors1ListEvent>(onHapusEndors1List);
		on<CloseDialogEndors1ListEvent>(onCloseDialogEndors1List);
	}

	Future<void> onRefreshEndors1List(
			RefreshEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		emit(const Endors1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchEndors1ListEvent());
	}

	Future<void> onFetchEndors1List(
			FetchEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		if (state.hasReachedMax) return;

		Endors1ListRepository repo = Endors1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Endors1ListModel> items = await repo.getEndors1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Endors1ListModel> items = await repo.getEndors1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Endors1ListModel> endors1List = List.of(state.items)..addAll(items);

			final result = endors1List
				.whereWithIndex((e, index) =>
					endors1List.indexWhere((e2) => e2.endors1Id == e.endors1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusEndors1List(
		HapusEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogEndors1List(
		CloseDialogEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahEndors1List(
		TambahEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahEndors1List(
		UbahEndors1ListEvent event, Emitter<Endors1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}