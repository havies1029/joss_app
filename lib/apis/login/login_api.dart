import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/user/user_model.dart';

class LoginApi {
  final _base = AppData.apiDomain;

  Future<User> validateUserLoginAPI(UserLogin userLogin) async {
    String tokenEndpoint = "api/login/apilogin";
    final tokenURL = _base + tokenEndpoint;
    UserInfo userinfo = UserInfo(userLogin: userLogin);

    debugPrint("validateUserLogin #10");

    //debugPrint(tokenURL);
    //debugPrint(jsonEncode(userinfo.toJson()));

    try {
      await http.post(Uri.parse(tokenURL),
          headers: <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json; odata=verbos',
            'Accept': 'application/json; odata=verbos'
          },
          //body: jsonEncode(userLogin.toDatabaseJson()),

          body: jsonEncode(userinfo.toJson()));
    } catch (e) {
      debugPrint("error : ${e.toString()}");
    }

    final http.Response response = await http.post(Uri.parse(tokenURL),
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos'
        },
        //body: jsonEncode(userLogin.toDatabaseJson()),

        body: jsonEncode(userinfo.toJson()));

    //debugPrint("validateUserLogin #12");

    //debugPrint("response.statusCode : ${response.statusCode}");

    //debugPrint("validateUserLogin #20");

    if (response.statusCode == 200) {
      //debugPrint("Berhasil Login #30");

      //debugPrint(jsonDecode(response.body));

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
            email: info[5],
            userCabang: info[1],
            userType: "C",
            cstType: info[6],);
        return user;
      } on Exception {
        //debugPrint("Error : ${e.toString()}");
        rethrow;
      }
    } else {
      //debugPrint("validateUserLogin #25");
      //debugPrint(jsonDecode(response.body));
      throw Exception(json.decode(response.body));
    }
  }

  Future<User?> getUserByTokenAPI(String token) async {
    String urlGetUserEndPoint = "${AppData.prefixEndPoint}/api/login/getuser";

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetUserEndPoint);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer $token'
    });

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
            hp: info[4],
            userType: info[0],
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
