part of 'chatgroupcari_bloc.dart';

abstract class ChatGroupCariEvents extends Equatable {
  const ChatGroupCariEvents();

  @override
  List<Object> get props => [];
}

class FetchChatGroupCariEvent extends ChatGroupCariEvents {
  final int hal;
  final String roomId;
  final DateTime lastFetch;

  const FetchChatGroupCariEvent({required this.hal, required this.roomId, required this.lastFetch});

  @override
  List<Object> get props => [hal, roomId, lastFetch];
}

class RefreshChatGroupCariEvent extends ChatGroupCariEvents {
  final int hal;
  final String roomId;

  const RefreshChatGroupCariEvent({required this.hal, required this.roomId});

  @override
  List<Object> get props => [hal, roomId];
}

class ResetStateEvent extends ChatGroupCariEvents {}