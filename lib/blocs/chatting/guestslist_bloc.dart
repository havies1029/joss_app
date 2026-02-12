import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/chatting/guestslist_model.dart';
import 'package:joss_app/repositories/chatting/guestslist_repository.dart';

part 'guestslist_event.dart';
part 'guestslist_state.dart';

class GuestsListBloc extends Bloc<GuestsListEvents, GuestsListState> {
	GuestsListBloc() : super(const GuestsListState()) {
		on<FetchGuestsListEvent>(onFetchGuestsList);
		on<RefreshGuestsListEvent>(onRefreshGuestsList);
		on<UbahGuestsListEvent>(onUbahGuestsList);
		on<TambahGuestsListEvent>(onTambahGuestsList);
		on<HapusGuestsListEvent>(onHapusGuestsList);
		on<CloseDialogGuestsListEvent>(onCloseDialogGuestsList);
	}

	Future<void> onRefreshGuestsList(
			RefreshGuestsListEvent event, Emitter<GuestsListState> emit) async {
		emit(const GuestsListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchGuestsListEvent());
	}

	Future<void> onFetchGuestsList(
			FetchGuestsListEvent event, Emitter<GuestsListState> emit) async {
		if (state.hasReachedMax) return;

		GuestsListRepository repo = GuestsListRepository();
		if (state.status == ListStatus.initial) {
			List<GuestsListModel> items = await repo.getGuestsList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<GuestsListModel> items = await repo.getGuestsList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<GuestsListModel> guestsList = List.of(state.items)..addAll(items);

			final result = guestsList
				.whereWithIndex((e, index) =>
					guestsList.indexWhere((e2) => e2.guestsId == e.guestsId) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusGuestsList(
		HapusGuestsListEvent event, Emitter<GuestsListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogGuestsList(
		CloseDialogGuestsListEvent event, Emitter<GuestsListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahGuestsList(
		TambahGuestsListEvent event, Emitter<GuestsListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahGuestsList(
		UbahGuestsListEvent event, Emitter<GuestsListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}