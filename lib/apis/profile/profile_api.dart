import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/user/user_model.dart';

final _base = AppData.apiDomain;
const _updateProfileEndpoint = "api/userprofile/update";
final _updateProfileURL = _base + _updateProfileEndpoint;

Future<bool> updateUserProfile(User user) async {
  //debugPrint("updateUserProfile");

  //debugPrint("Token : ${user.token}");

  final http.Response response = await http.post(Uri.parse(_updateProfileURL),
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${user.token!}'
      },
      //body: jsonEncode(userLogin.toDatabaseJson()),
      body: jsonEncode(user.toDatabaseJson()));

  if (response.statusCode == 200) {
    return true;
  } else {
    //throw Exception(json.decode(response.body));
    return false;
  }
}
