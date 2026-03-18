import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import '../../models/combobox/combomcobapp1_model.dart';

class ComboMCobApp1API {
  Future<List<ComboMCobApp1Model>> getComboMCobApp1API(String filter) async {
    String urlGetComboEndPoint =
        "${AppData.prefixEndPoint}/api/mcobapp1combobox/getlist";

    Map<String, String> queryParams = {"filter": filter};

    var uri = AppData.uriHtpp(
      AppData.httpAuthority,
      urlGetComboEndPoint,
      queryParams,
    );

    try {
      debugPrint("COB API REQUEST: $uri");

      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
      );

      debugPrint("COB API STATUS: ${response.statusCode}");
      debugPrint("COB API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<ComboMCobApp1Model>((json) =>
            ComboMCobApp1Model.fromJson(json))
            .toList();
      } else {
        debugPrint("COB API ERROR: status ${response.statusCode}");
        throw Exception("Failed to load data");
      }
    } catch (e, stack) {
      debugPrint("COB API EXCEPTION: $e");
      debugPrint("COB API STACKTRACE: $stack");
      rethrow;
    }
  }
}