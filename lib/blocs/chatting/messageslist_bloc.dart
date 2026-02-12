import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/chatting/messageslist_model.dart';
import 'package:joss_app/repositories/chatting/messageslist_repository.dart';

part 'messageslist_event.dart';
part 'messageslist_state.dart';

class MessagesListBloc extends Bloc<MessagesListEvents, MessagesListState> {
	MessagesListBloc() : super(const MessagesListState()) {
		on<FetchMessagesListEvent>(onFetchMessagesList);
		on<RefreshMessagesListEvent>(onRefreshMessagesList);
		on<UbahMessagesListEvent>(onUbahMessagesList);
		on<TambahMessagesListEvent>(onTambahMessagesList);
		on<HapusMessagesListEvent>(onHapusMessagesList);
		on<CloseDialogMessagesListEvent>(onCloseDialogMessagesList);
	}

	Future<void> onRefreshMessagesList(
			RefreshMessagesListEvent event, Emitter<MessagesListState> emit) async {
		emit(const MessagesListState());

		emit(state.copyWith(searchText: event.searchText));
		add(FetchMessagesListEvent());
	}

	Future<void> onFetchMessagesList(
			FetchMessagesListEvent event, Emitter<MessagesListState> emit) async {
		if (state.hasReachedMax) return;

		MessagesListRepository repo = MessagesListRepository();
		if (state.status == ListStatus.initial) {
			List<MessagesListModel> items = await repo.getMessagesList(state.searchText, 0);
			return emit(state.copyWith(
				items: items,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: 1));
		}
		List<MessagesListModel> items = await repo.getMessagesList(state.searchText, state.hal);
		if (items.isEmpty) {
			return emit(state.copyWith(hasReachedMax: true));
		} else {
			List<MessagesListModel> messagesList = List.of(state.items)..addAll(items);

			final result = messagesList
				.whereWithIndex((e, index) =>
					messagesList.indexWhere((e2) => e2.id == e.id) ==
					index)
				.toList();

			return emit(state.copyWith(
				items: result,
				hasReachedMax: false,
				status: ListStatus.success,
				hal: state.hal + 1));
		}
	}

	Future<void> onHapusMessagesList(
		HapusMessagesListEvent event, Emitter<MessagesListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "hapus"));
	}

	Future<void> onCloseDialogMessagesList(
		CloseDialogMessagesListEvent event, Emitter<MessagesListState> emit) async {
		emit(state.copyWith(viewMode: ""));
	}

	Future<void> onTambahMessagesList(
		TambahMessagesListEvent event, Emitter<MessagesListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "tambah"));
	}

	Future<void> onUbahMessagesList(
		UbahMessagesListEvent event, Emitter<MessagesListState> emit) async {
		emit(state.copyWith(viewMode: ""));
		emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
	}

}