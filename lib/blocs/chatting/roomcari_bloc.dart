import 'package:equatable/equatable.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/chatting/roomcari_model.dart';
import 'package:joss_app/repositories/chatting/roomcari_repository.dart';

part 'roomcari_event.dart';
part 'roomcari_state.dart';

class RoomCariBloc extends Bloc<RoomCariEvents, RoomCariState> {
	RoomCariBloc() : super(const RoomCariState()) {
		on<FetchRoomCariEvent>(onFetchRoomCari);
		on<RefreshRoomCariEvent>(onRefreshRoomCari);
	}

Future<void> onRefreshRoomCari(
		RefreshRoomCariEvent event, Emitter<RoomCariState> emit) async {
	emit(const RoomCariState());

	//await Future.delayed(const Duration(seconds: 1));

	add(FetchRoomCariEvent(hal: 0, searchText: event.searchText));
}

Future<void> onFetchRoomCari(
		FetchRoomCariEvent event, Emitter<RoomCariState> emit) async {
	if (state.hasReachedMax) return;

	RoomCariRepository repo = RoomCariRepository();
	if (state.status == ListStatus.initial) {
		List<RoomCariModel> items = await repo.getRoomCari(event.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: 1));
	}
	List<RoomCariModel> items = await repo.getRoomCari(event.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<RoomCariModel> roomCari = List.of(state.items)..addAll(items);

		final result = roomCari
			.whereWithIndex((e, index) =>
				roomCari.indexWhere((e2) => e2.chatroomId == e.chatroomId) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
			hal: state.hal + 1));
		}

	}
}