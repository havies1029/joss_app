import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_regmv/regmv1list_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv1list_repository.dart';

part 'regmv1list_event.dart';
part 'regmv1list_state.dart';

class Regmv1ListBloc extends Bloc<Regmv1ListEvents, Regmv1ListState> {
	Regmv1ListBloc() : super(const Regmv1ListState()) {
		on<FetchRegmv1ListEvent>(onFetchRegmv1List);
		on<RefreshRegmv1ListEvent>(onRefreshRegmv1List);
		on<UbahRegmv1ListEvent>(onUbahRegmv1List);
		on<TambahRegmv1ListEvent>(onTambahRegmv1List);
		on<HapusRegmv1ListEvent>(onHapusRegmv1List);
		on<CloseDialogRegmv1ListEvent>(onCloseDialogRegmv1List);
	}

	Future<void> onRefreshRegmv1List(
			RefreshRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		emit(const Regmv1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchRegmv1ListEvent());
	}

	Future<void> onFetchRegmv1List(
			FetchRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		if (state.hasReachedMax) return;

		Regmv1ListRepository repo = Regmv1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Regmv1ListModel> items = await repo.getRegmv1List(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<Regmv1ListModel> items = await repo.getRegmv1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Regmv1ListModel> regmv1List = List.of(state.items)..addAll(items);

			final result = regmv1List
				.whereWithIndex((e, index) =>
					regmv1List.indexWhere((e2) => e2.regmv1Id == e.regmv1Id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusRegmv1List(
		HapusRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogRegmv1List(
		CloseDialogRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahRegmv1List(
		TambahRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahRegmv1List(
		UbahRegmv1ListEvent event, Emitter<Regmv1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}