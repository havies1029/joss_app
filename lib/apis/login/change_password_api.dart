import 'dart:convert';

import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/authentication/reset_password_model.dart';

class ChangePasswordApi {
  Future<bool> changePasswordApi(ChangePasswordModel pswd) async {
    String changePswdEndpoint =
        "${AppData.prefixEndPoint}/api/login/changepswd";
    Map<String, String> queryParams = {"modul_id": "changePasswordApi"};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, changePswdEndpoint, queryParams);
    final http.Response response = await http.post(uri,
        headers: AppData.httpHeaders, body: jsonEncode(pswd.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  
}
