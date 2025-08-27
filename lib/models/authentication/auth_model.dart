import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:string_validator/string_validator.dart';

class UserInfo {
  UserLogin? userLogin;

  UserInfo({this.userLogin});

  Map<String, dynamic> toJson() => {"userinfo": userLogin?.toDatabaseJson()};
}

class UserLogin {
  String? email;
  String? password;

  UserLogin({this.email, this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"email": email, "password": password};
}

class Token {
  String? token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }

  factory Token.split(String username, String tokeninfo) {
    debugPrint("Token.split");

    //debugPrint("tokeninfo : $tokeninfo");

    List<String> info = tokeninfo.split(";");
    //String credentials = _info[2] + ":" + _info[0];
    String credentials = "$username:${info[0]}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String enkriptToken = stringToBase64.encode(credentials);

    //debugPrint("encripted token : $enkriptToken");

    AppData.userToken = enkriptToken;
    //AppData.userCabang = info[1];
    //AppData.personId = info[12];
    //AppData.personName = info[2];
    //AppData.hasDownline = toBoolean(info[6], false);
    AppData.httpHeaders = <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    //debugPrint("AppData.userCabang : ${AppData.userCabang}");

    //String dekripToken = stringToBase64.decode(enkriptToken);
    //debugPrint("dekrip Token : $dekripToken");

    return Token(token: enkriptToken);
  }
}
