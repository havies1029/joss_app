import 'dart:async';
import 'dart:convert';
import 'package:const_date_time/const_date_time.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/chatting/chatgroupcrud_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'chatgroupcari_event.dart';
part 'chatgroupcari_state.dart';

class ChatGroupCariBloc extends Bloc<ChatGroupCariEvents, ChatGroupCariState> {
  ChatGroupCariBloc() : super(const ChatGroupCariState()) {
    on<FetchChatGroupCariEvent>(onFetchChatGroupCari);
    on<RefreshChatGroupCariEvent>(onRefreshChatGroupCari);
    on<ResetStateEvent>(onResetState);
  }

  Future<void> onResetState(
      ResetStateEvent event, Emitter<ChatGroupCariState> emit) async {
    emit(const ChatGroupCariState());
  }

  Future<void> onRefreshChatGroupCari(
      RefreshChatGroupCariEvent event, Emitter<ChatGroupCariState> emit) async {
    debugPrint("onRefreshChatGroupCari");

    //emit(const ChatGroupCariState());

    //await Future.delayed(const Duration(seconds: 1));

    //add(FetchChatGroupCariEvent(hal: 0, roomId: event.roomId));

    ChatGroupCrudRepository repo = ChatGroupCrudRepository();
    //if (state.status == ListStatus.initial) {
    debugPrint("ListStatus #15 : ${state.status}");
    final response = await repo.getChatGroupCari(event.roomId, 0);
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    debugPrint("items count : ${messages.length}");

    //List<types.Message> listMessages = List.of(state.items)..addAll(messages);
    List<types.Message> listMessages = List.of(state.items)
      ..insertAll(0, messages);

    final result = listMessages
        .whereWithIndex((e, index) =>
            listMessages.indexWhere((e2) => e2.id == e.id) == index)
        .toList();

    return emit(state.copyWith(
        items: result,
        //items: messages,
        //hasReachedMax: false,
        status: ListStatus.success,
        hal: state.hal));
    //}
  }

  Future<void> onFetchChatGroupCari(
      FetchChatGroupCariEvent event, Emitter<ChatGroupCariState> emit) async {
    debugPrint("onFetchChatGroupCari");

    emit(state.copyWith(lastFetch: event.lastFetch));

    if (state.hasReachedMax) return;

    ChatGroupCrudRepository repo = ChatGroupCrudRepository();
    final response = await repo.getChatGroupCari(event.roomId, event.hal);
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    if (messages.isEmpty) {
      debugPrint("onFetchChatGroupCari -> messages.isEmpty");
      return emit(state.copyWith(hasReachedMax: true));
    } else {
      List<types.Message> listMessages = List.of(state.items)..addAll(messages);

      var result = listMessages
          .whereWithIndex((e, index) =>
              listMessages.indexWhere((e2) => e2.id == e.id) == index)
          .toList();

      return emit(state.copyWith(
          items: result,
          hasReachedMax: false,
          status: ListStatus.success,
          hal: event.hal,
          lastFetch: event.lastFetch));
    }
  }
}
