import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/onboardmenu/onboardmenucari_model.dart';

class OnBoardMenuCariAPI {
  Future<OnBoardMenuCariModel> getOnBoardMenuCariAPI() async {
    String urlGetListEndPoint =
        "${AppData.prefixEndPoint}/api/onboardmenu/onboardmenucari/getlist";

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    if (response.statusCode == 200) {
      /*
      debugPrint("OnBoardMenuCariAPI response.body : ${response.body}");
      debugPrint(
          "response.statusCode : ${response.statusCode}");
      debugPrint(
          "json.decode(response.body) : ${json.decode(response.body)}");
      */
      OnBoardMenuCariModel menu =
          OnBoardMenuCariModel.fromJson(json.decode(response.body));

      //debugPrint("menu : ${menu.toJson()}");

      return menu;
    } else {
      throw Exception("Failed to load data");
    }
  }
}
