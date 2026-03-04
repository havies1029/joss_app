class UserToken {
  int? id;
  String? token;
  String? userType;

  UserToken({this.id, this.token, this.userType = ""});

  factory UserToken.fromDatabaseJson(Map<String, dynamic> data) => UserToken(
    id: data['id'],
    token: data['token'],
    userType: data['userType'] ?? "",
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": id,
    "token": token,
    "userType": userType,
  };
}
