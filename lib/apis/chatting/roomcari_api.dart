import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/chatting/roomcari_model.dart';

String urlGetListEndPoint =
    "${AppData.prefixEndPoint}/api/groupchat/roomcari/getlist";

Future<List<RoomCariModel>> getRoomCariAPI(String searchText, int hal) async {
  Map<String, String> queryParams = {
    "searchText": searchText,
    "hal": hal.toString()
  };

  var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

  final http.Response response = await http.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; odata=verbos',
    'Accept': 'application/json; odata=verbos',
    'Authorization': 'Bearer ${AppData.userToken}'
  });

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed
        .map<RoomCariModel>((json) => RoomCariModel.fromJson(json))
        .toList();
  } else {
    throw Exception("Failed to load data");
  }
}
