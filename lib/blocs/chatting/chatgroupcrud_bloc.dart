import 'package:joss_app/models/chatting/groupchat_model.dart';
import 'package:joss_app/repositories/chatting/chatgroupcrud_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/responseAPI/returndataapi_model.dart';

part 'chatgroupcrud_event.dart';
part 'chatgroupcrud_state.dart';

class ChatGroupCrudBloc extends Bloc<ChatGroupCrudEvents, ChatGroupCrudState> {
  final ChatGroupCrudRepository chatGroupRepository;

  ChatGroupCrudBloc({required this.chatGroupRepository})
      : super(const ChatGroupCrudState()) {
    on<AddTextChatGroupEvent>(onTambahTextChatGroup);
    on<AddAttachmentChatGroupEvent>(onTambahAttachmentChatGroup);
  }

  Future<void> onTambahTextChatGroup(
      AddTextChatGroupEvent event, Emitter<ChatGroupCrudState> emit) async {
    //debugPrint("#### onTambahMember ####");

    ReturnDataAPI returnData;
    bool hasFailure = true;

    emit(state.copyWith(isSaving: true, isSaved: false));

    //debugPrint("#### onTambahMember #### -> 10");

    returnData =
        await chatGroupRepository.addTextMessageGroupChat(event.chatmsg);

    //debugPrint("#### onTambahMember #### -> 20");

    hasFailure = !returnData.success;
    //debugPrint("#### onTambahMember #### -> 22");
    GroupchatModel dataChat = event.chatmsg;
    //debugPrint("#### onTambahMember #### -> 24");
    //dataChat.chatmsgId = int.parse(returnData.data) as Int32;

    //debugPrint("#### onTambahMember #### -> 30");

    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: hasFailure,
        chatmsg: dataChat,
        viewMode: "ubah"));

    //debugPrint("#### onTambahMember #### -> 40");
  }

  Future<void> onTambahAttachmentChatGroup(AddAttachmentChatGroupEvent event,
      Emitter<ChatGroupCrudState> emit) async {
    //debugPrint("#### onTambahMember ####");

    ReturnDataAPI returnData;
    bool hasFailure = true;

    emit(state.copyWith(isSaving: true, isSaved: false));

    //debugPrint("#### onTambahMember #### -> 10");

    returnData =
        await chatGroupRepository.addAttachmentGroupChat(event.chatmsg);

    //debugPrint("#### onTambahMember #### -> 20");

    hasFailure = !returnData.success;
    //debugPrint("#### onTambahMember #### -> 22");
    GroupchatModel dataChat = event.chatmsg;
    //debugPrint("#### onTambahMember #### -> 24");
    //dataChat.chatmsgId = int.parse(returnData.data) as Int32;

    //debugPrint("#### onTambahMember #### -> 30");

    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: hasFailure,
        chatmsg: dataChat,
        viewMode: "ubah"));

    //debugPrint("#### onTambahMember #### -> 40");
  }
}
