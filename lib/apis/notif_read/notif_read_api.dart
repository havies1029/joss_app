import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';

import '../../models/notif_read/notif_read_model.dart';

class NotifReadApi {
  Future<bool> markNotifRead({
    required String modulId,
    required String notifType,
    required String notifId,
  }) async {
    String urlEndPoint = "${AppData.prefixEndPoint}/api/notifevent/mark";

    var queryParameters = {
      'modul_id': modulId,
    };

    var uri = AppData.uriHtpp(
      AppData.httpAuthority,
      urlEndPoint,
      queryParameters,
    );

    final body = NotifReadModel(
      notifType: notifType,
      notifId: notifId,
    ).toJson();

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['success'] == true;
    } else {
      throw Exception("Failed to mark notif read");
    }
  }

  Future<int> getNotifUnreadCount() async {
    String urlEndPoint =
        "${AppData.prefixEndPoint}/api/notifevent/unread-count";

    var uri = AppData.uriHtpp(
      AppData.httpAuthority,
      urlEndPoint,
    );

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['unreadCount'] ?? 0;
    } else {
      throw Exception("Failed to load unread count");
    }
  }
}