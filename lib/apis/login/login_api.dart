import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/user/user_model.dart';

class LoginUnverifiedRegisterException implements Exception {
  final String rawData;
  final String userId;
  final String phone;
  final String email;

  const LoginUnverifiedRegisterException({
    required this.rawData,
    required this.userId,
    required this.phone,
    required this.email,
  });

  factory LoginUnverifiedRegisterException.fromResponseBody(String body) {
    String data = body;
    try {
      final decoded = jsonDecode(body);
      if (decoded is String) {
        data = decoded;
      }
    } catch (_) {}

    final parts = data.split(';');
    return LoginUnverifiedRegisterException(
      rawData: data,
      userId: parts.length > 1 ? parts[1] : '',
      phone: parts.length > 2 ? parts[2] : '',
      email: parts.length > 3 ? parts[3] : '',
    );
  }

  @override
  String toString() => rawData;
}

class LoginApi {
  final _base = AppData.apiDomain;

  String _maskLoginResponseBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is String) {
        final parts = decoded.split(";");
        if (parts.isNotEmpty) {
          parts[0] = "<token hidden>";
        }
        return jsonEncode(parts.join(";"));
      }
    } catch (_) {}

    return "<body hidden, length: ${body.length}>";
  }

  Future<User> validateUserLoginAPI(UserLogin userLogin) async {
    String tokenEndpoint = "api/login/apilogin";
    final tokenURL = _base + tokenEndpoint;
    UserInfo userinfo = UserInfo(userLogin: userLogin);
    final requestBody = jsonEncode(userinfo.toJson());

    debugPrint("========== LOGIN REQUEST ==========");
    debugPrint("URL      : $tokenURL");
    debugPrint("METHOD   : POST");
    debugPrint("BODY     : ${jsonEncode({
          "userinfo": {
            "email": userLogin.email,
            "password": (userLogin.password?.isEmpty ?? true) ? "" : "********",
          }
        })}");

    final http.Response response = await http.post(Uri.parse(tokenURL),
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
        },
        body: requestBody);

    debugPrint("========== LOGIN RESPONSE ==========");
    debugPrint("STATUS CODE : ${response.statusCode}");
    debugPrint("BODY        : ${_maskLoginResponseBody(response.body)}");


    if (response.statusCode == 200) {
      
      String tokeninfo = jsonDecode(response.body);
      List<String> info = tokeninfo.split(";");
      String username = info[8];
      Token token = Token.split(username, tokeninfo);

      try {
        User user = User(
            id: 0,
            token: token.token,
            username: username,
            nama: info[2],
            hp: info[4],
            email: info[5],
            userCabang: info[1],
            userType: "C",
            cstType: info[6],);
        return user;
      } on Exception {
        //debugPrint("Error : ${e.toString()}");
        rethrow;
      }
    } else if (response.statusCode == 409) {
      final error =
          LoginUnverifiedRegisterException.fromResponseBody(response.body);
      if (error.rawData.startsWith('UNVERIFIED_REGISTER')) {
        throw error;
      }
      throw Exception(error.rawData);
    } else {
      //debugPrint("validateUserLogin #25");
      //debugPrint(jsonDecode(response.body));
      throw Exception(json.decode(response.body));
    }
  }

  Future<User?> getUserByTokenAPI(String token) async {
    String urlGetUserEndPoint = "${AppData.prefixEndPoint}/api/login/getuser";

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetUserEndPoint);
    debugPrint("========== GET USER REQUEST ==========");
    debugPrint("URL      : $uri");
    debugPrint("METHOD   : GET");
    debugPrint("TOKEN    : ${token.isEmpty ? '' : '<token hidden>'}");

    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer $token'
    });

    debugPrint("========== GET USER RESPONSE ==========");
    debugPrint("STATUS CODE : ${response.statusCode}");
    debugPrint("BODY        : ${response.body}");

    if (response.statusCode == 200) {
      String result = jsonDecode(response.body);
      List<String> info = result.split(";");
      if (info[0] == "U") {
        User user = User(
            id: 0,
            token: token,
            username: info[1],
            nama: info[1],
            email: info[2],
            userType: info[0],);
        return user;
      } else if (info[0] == "C") {
        User user = User(
            id: 0,
            token: token,
            username: info[1],
            nama: info[2],
            email: info[3],
            userType: info[0],
            hp: info[4],
            cstType: info[5],);
        return user;
      } else {
        debugPrint("User not found or invalid token");
        return null;
        //throw Exception("User not found or invalid token");
      }
    } else {
      debugPrint("Failed to load data getUserByTokenAPI: ${response.statusCode}");
      return null;
      //throw Exception("Failed to load data getUserByTokenAPI: ${response.statusCode}");
    }
  }
}
