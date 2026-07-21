import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';
import 'package:flutter/foundation.dart';

class Regmv1CrudAPI {
  Future<ReturnDataAPI> regmv1CrudTambahAPI(Regmv1CrudModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv1crud/create";
    Map<String, String> queryParams = {"modul_id": "regmv1CrudTambahAPI"};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

    debugPrint("📡 [API CALL] POST $uri");
    debugPrint("📦 [REQUEST BODY] ${jsonEncode(record.toJson())}");

    ReturnDataAPI returnData;
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}'
      },
      body: jsonEncode(record.toJson()),
    );

    debugPrint("🟩 [STATUS CODE] ${response.statusCode}");
    debugPrint("🟦 [RESPONSE BODY] ${response.body}");

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      try {
        returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
        debugPrint(
            "✅ [PARSE OK] success=${returnData.success}, rowcount=${returnData.rowcount}");
      } catch (e) {
        debugPrint("❌ [PARSE ERROR] $e");
        returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } else {
      debugPrint("🚨 [SERVER ERROR] ${response.reasonPhrase}");
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData;
  }

  Future<bool> regmv1CrudUbahAPI(Regmv1CrudModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv1crud/update";
    Map<String, String> queryParams = {"modul_id": "regmv1CrudUbahAPI"};

    var uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);
    debugPrint("📡 [API CALL] POST $uri");
    debugPrint("📦 [REQUEST BODY] ${jsonEncode(record.toJson())}");

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}'
      },
      body: jsonEncode(record.toJson()),
    );

    debugPrint("🟩 [STATUS CODE] ${response.statusCode}");
    debugPrint("🟦 [RESPONSE BODY] ${response.body}");

    ReturnDataAPI returnData;
    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      try {
        returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
        debugPrint("✅ [UPDATE OK] success=${returnData.success}");
      } catch (e) {
        debugPrint("❌ [PARSE ERROR] $e");
        returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } else {
      debugPrint("🚨 [SERVER ERROR] ${response.reasonPhrase}");
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData.success;
  }

  Future<bool> regmv1CrudHapusAPI(String regmv1Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv1crud/delete";
    Map<String, String> queryParams = {
      'regmv1Id': regmv1Id,
      'modul_id': 'regmv1CrudHapusAPI'
    };
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);

    debugPrint("📡 [API CALL] GET $uri");

    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    debugPrint("🟩 [STATUS CODE] ${response.statusCode}");
    debugPrint("🟦 [RESPONSE BODY] ${response.body}");

    ReturnDataAPI returnData;
    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      try {
        returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
        debugPrint("✅ [DELETE OK] success=${returnData.success}");
      } catch (e) {
        debugPrint("❌ [PARSE ERROR] $e");
        returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } else {
      debugPrint("🚨 [SERVER ERROR] ${response.reasonPhrase}");
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData.success;
  }

  Future<Regmv1CrudModel> regmv1CrudLihatAPI(String regmv1Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv1crud/read";
    Map<String, String> queryParams = {'regmv1Id': regmv1Id};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

    debugPrint("📡 [API CALL] GET $uri");

    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    debugPrint("🟩 [STATUS CODE] ${response.statusCode}");
    debugPrint("🟦 [RESPONSE BODY] ${response.body}");

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      try {
        var returnData = Regmv1CrudModel.fromJson(jsonDecode(response.body));
        debugPrint("✅ [READ OK] record id=${returnData.regmv1Id}");
        return returnData;
      } catch (e) {
        debugPrint("❌ [PARSE ERROR] $e");
        throw Exception("Failed to parse data");
      }
    } else {
      debugPrint("🚨 [SERVER ERROR] ${response.reasonPhrase}");
      throw Exception("Failed to load data");
    }
  }
}
