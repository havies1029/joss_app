import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/notifevent/notif_email_setting_model.dart';

class NotifEmailSettingApi {
  Future<NotifEmailSettingModel> read() async {
    final urlEndPoint =
        "${AppData.prefixEndPoint}/api/notifevent/notifemail/read";

    final uri = AppData.uriHtpp(AppData.httpAuthority, urlEndPoint);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    if (response.statusCode == 200) {
      return NotifEmailSettingModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load notif email setting");
  }

  Future<bool> update(bool isNotifEmail) async {
    final urlEndPoint =
        "${AppData.prefixEndPoint}/api/notifevent/notifemail/update";

    final uri = AppData.uriHtpp(AppData.httpAuthority, urlEndPoint);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
      body: jsonEncode({
        'isnotifemail': isNotifEmail,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }

    throw Exception("Failed to update notif email setting");
  }
}
