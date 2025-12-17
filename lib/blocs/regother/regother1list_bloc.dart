import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/regother/regother1list_model.dart';
import 'package:joss_app/repositories/regother/regother1list_repository.dart';

part 'regother1list_event.dart';
part 'regother1list_state.dart';

class Regother1ListBloc extends Bloc<Regother1ListEvents, Regother1ListState> {
	Regother1ListBloc() : super(const Regother1ListState()) {
		on<FetchRegother1ListEvent>(onFetchRegother1List);
		on<RefreshRegother1ListEvent>(onRefreshRegother1List);
		on<UbahRegother1ListEvent>(onUbahRegother1List);
		on<TambahRegother1ListEvent>(onTambahRegother1List);
		on<HapusRegother1ListEvent>(onHapusRegother1List);
		on<CloseDialogRegother1ListEvent>(onCloseDialogRegother1List);
	}

	Future<void> onRefreshRegother1List(
			RefreshRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		emit(const Regother1ListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchRegother1ListEvent());
	}

	Future<void> onFetchRegother1List(
			FetchRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		if (state.hasReachedMax) return;

		Regother1ListRepository repo = Regother1ListRepository();
		if (state.status == ListStatus.initial) {
			List<Regother1ListModel> items = await repo.getRegother1List(state.searchText, 0);
			return emit(state.copyWith(
					items: items,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: 1));
		}
		List<Regother1ListModel> items = await repo.getRegother1List(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<Regother1ListModel> regother1List = List.of(state.items)..addAll(items);

			final result = regother1List
					.whereWithIndex((e, index) =>
			regother1List.indexWhere((e2) => e2.regother1Id == e.regother1Id) ==
					index)
					.toList();

			return emit(state.copyWith(
					items: result,
					hasReachedMax: false,
					status: ListStatus.success,
					hal: state.hal + 1));
		}
	}

	Future<void> onHapusRegother1List(
			HapusRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogRegother1List(
			CloseDialogRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahRegother1List(
			TambahRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahRegother1List(
			UbahRegother1ListEvent event, Emitter<Regother1ListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}