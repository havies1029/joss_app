import 'dart:async';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/apis/login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<User> authenticate({
    String? email,
    String? password,
  }) async {
    UserLogin userLogin = UserLogin(email: email, password: password);
    LoginApi loginApi = LoginApi();
    User user = await loginApi.validateUserLoginAPI(userLogin);

    return user;
  }

  Future<void> persistToken({required String userToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', userToken);
  }

  Future<void> deleteToken({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    return token ?? "";
  }

  Future<User> getUserByToken(String token) async {
    debugPrint("getUserByToken : $token");
    LoginApi loginApi = LoginApi();
    User user = await loginApi.getUserByTokenAPI(token);
    return user;
  }
}
