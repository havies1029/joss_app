part of 'chatgroupcrud_bloc.dart';

abstract class ChatGroupCrudEvents extends Equatable {
  const ChatGroupCrudEvents();

  @override
  List<Object> get props => [];
}

class AddTextChatGroupEvent extends ChatGroupCrudEvents {
  final GroupchatModel chatmsg;
  const AddTextChatGroupEvent({required this.chatmsg});

  @override
  List<Object> get props => [chatmsg];
}

class AddAttachmentChatGroupEvent extends ChatGroupCrudEvents {
  final GroupchatModel chatmsg;
  const AddAttachmentChatGroupEvent({required this.chatmsg});

  @override
  List<Object> get props => [chatmsg];
}
