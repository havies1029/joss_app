
class MessagesCrudModel {
	String content;
	DateTime createdAt;
	String id;
	String messageType;
	String senderType;

	MessagesCrudModel({required this.content, required this.createdAt, 
		required this.id, required this.messageType, 
		required this.senderType});

	factory MessagesCrudModel.fromJson(Map<String, dynamic> data) {
		return MessagesCrudModel(
			content: data['content']??'',
			createdAt: DateTime.tryParse(data['createdAt'].toString())??DateTime.now(),
			id: data['id']??'',
			messageType: data['messageType']??'',
			senderType: data['senderType']??''
		);

	}

	Map<String, dynamic> toJson() =>
		{'content': content,
		'createdAt': createdAt.toIso8601String(),
		'id': id,
		'messageType': messageType,
		'senderType': senderType};

}
