import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';

class Regmv3FormAPI {
  Future<ReturnDataAPI> regmv3FormTambahAPI(Regmv3FormModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv3form/create";
    Map<String, String> queryParams = {"modul_id": "regmv3FormTambahAPI"};
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

  Future<ReturnDataAPI> regmv3FormUbahAPI(Regmv3FormModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv3form/update";
    Map<String, String> queryParams = {"modul_id": "regmv3FormUbahAPI"};

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
    return returnData;
  }

  Future<bool> regmv3FormHapusAPI(String regmv3Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv3form/delete";
    Map<String, String> queryParams = {
      'regmv3Id': regmv3Id,
      'modul_id': 'regmv3FormHapusAPI'
    };
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    ReturnDataAPI returnData;
    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
    return returnData.success;
  }

  Future<Regmv3FormModel> regmv3FormLihatAPI(String regmv1Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/regmv/regmv3form/read";
    Map<String, String> queryParams = {'regmv1Id': regmv1Id};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
    debugPrint("=== REGMV3 LIHAT REQUEST ===");
    debugPrint("URI: $uri");
    debugPrint("============================");
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });
    debugPrint("=== REGMV3 LIHAT RESPONSE ===");
    debugPrint("Status: ${response.statusCode}");
    debugPrint("Body  : ${response.body}");
    debugPrint("=============================");

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      var returnData = Regmv3FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }
}
