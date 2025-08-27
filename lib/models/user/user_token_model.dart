class UserToken {
  int? id;
  String? token;
  String? custType;

  UserToken({this.id, this.token, this.custType = ""});

  factory UserToken.fromDatabaseJson(Map<String, dynamic> data) => UserToken(
    id: data['id'],
    token: data['token'],
    custType: data['custType'] ?? "",
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "token": token,
    "custType": custType,
  };
}
