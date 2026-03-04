
class MessagesListModel {
	int chatbotResponseId;
	String content;
	DateTime createdAt;
	String guestId;
	String id;
	String messageType;
	String senderId;
	String senderType;
	String ticketId;

	MessagesListModel({required this.chatbotResponseId, required this.content, 
		required this.createdAt, required this.guestId, 
		required this.id, required this.messageType, 
		required this.senderId, required this.senderType, 
		required this.ticketId});

	factory MessagesListModel.fromJson(Map<String, dynamic> data) {
		return MessagesListModel(
			chatbotResponseId: int.tryParse(data['chatbotResponseId'].toString())??0,
			content: data['content']??'',
			createdAt: DateTime.tryParse(data['createdAt'].toString())??DateTime.now(),
			guestId: data['guestId']??'',
			id: data['id']??'',
			messageType: data['messageType']??'',
			senderId: data['senderId']??'',
			senderType: data['senderType']??'',
			ticketId: data['ticketId']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'chatbotResponseId': chatbotResponseId.toString(),
		'content': content,
		'createdAt': createdAt.toIso8601String(),
		'guestId': guestId,
		'id': id,
		'messageType': messageType,
		'senderId': senderId,
		'senderType': senderType,
		'ticketId': ticketId};

}
