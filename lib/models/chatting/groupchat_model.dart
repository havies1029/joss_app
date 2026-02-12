import 'package:joss_app/models/chatting/author_model.dart';

class GroupchatModel {
  String roomId;
  double? height;
  String? name;
  num? size;
  String? uri;
  double? width;
  String id;
  int? createdAt;
  String? mimeType;
  String? text;
  String type;
  AuthorModel? author;

  GroupchatModel(
      { required this.roomId,
        this.name,
      this.size,
      this.uri,
      this.height,
      this.width,
      required this.id,
      required this.createdAt,
      this.mimeType,
      this.text,
      required this.type,
      this.author});

  factory GroupchatModel.fromJson(Map<String, dynamic> data) {
    AuthorModel chatAuthor = AuthorModel.fromJson(data["author"]);

    return GroupchatModel(
        roomId: data["roomId"],
        height: data['height'],
        name: data['name'],
        size: data['size'],
        uri: data['uri'],
        width: data['width'],
        id: data['id'],
        createdAt: data['createdAt'],
        mimeType: data['mimeType'],
        text: data['text'],
        type: data['type'],
        author: chatAuthor);
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'height': height,
      'name': name,
      'size': size,
      'uri': uri,
      'width': width,
      'id': id,
      'createdAt': createdAt,
      'mimeType': mimeType,
      'text': text,
      'type': type,
      'author': author?.toJson()
    };
  }
}
