class RoomCariModel {
	String chatgroupId;
	String chatroomId;
	String roomName;
	String groupName;

	RoomCariModel({required this.chatgroupId, required this.chatroomId, 
		required this.roomName, required this.groupName});

	factory RoomCariModel.fromJson(Map<String, dynamic> data) =>
		RoomCariModel(
			chatgroupId: data['chatgroupId']??"",
			chatroomId: data['chatroomId']??"",
			roomName: data['roomName']??"",
			groupName: data['groupName']??""
		);

	Map<String, dynamic> toJson() =>
		{'chatgroupId': chatgroupId,
		'chatroomId': chatroomId,
		'roomName': roomName,
		'groupName': groupName};

}
