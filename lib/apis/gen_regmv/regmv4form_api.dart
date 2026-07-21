import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv4form_model.dart';

class Regmv4FormAPI {
  Future<ReturnDataAPI> regmv4FormTambahAPI(Regmv4FormModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv4form/create";
    Map<String, String> queryParams = {"modul_id": "regmv4FormTambahAPI"};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

    ReturnDataAPI returnData;
    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
        body: jsonEncode(record.toJson()));

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData;
  }

  Future<bool> regmv4FormUbahAPI(Regmv4FormModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv4form/update";
    Map<String, String> queryParams = {"modul_id": "regmv4FormUbahAPI"};

    var uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
        body: jsonEncode(record.toJson()));

    ReturnDataAPI returnData;
    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData.success;
  }

  Future<bool> regmv4FormHapusAPI(String regmv4Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv4form/delete";
    Map<String, String> queryParams = {
      'regmv4Id': regmv4Id,
      'modul_id': 'regmv4FormHapusAPI'
    };

    var uri =
        AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);

    // 🔥 LOG REQUEST
    debugPrint("\n===== 🗑️ DELETE STNK API CALL =====");
    debugPrint("URL       : $uri");
    debugPrint("regmv4Id  : $regmv4Id");
    debugPrint("TOKEN LEN : ${AppData.userToken.length}");
    debugPrint("TOKEN HEAD: ${AppData.userToken.substring(0, 12)}...");
    debugPrint("====================================");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    // 🔥 LOG RESPONSE
    debugPrint("STATUS    : ${response.statusCode}");
    debugPrint("BODY      : ${response.body}");

    ReturnDataAPI returnData;

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }

    debugPrint("RESULT    : ${returnData.success}");
    debugPrint("===== 🗑️ END DELETE API =====\n");

    return returnData.success;
  }

  Future<Regmv4FormModel> regmv4FormLihatAPI(String regmv4Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv4form/read";
    Map<String, String> queryParams = {'regmv4Id': regmv4Id};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      var returnData = Regmv4FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }
}
