import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regpar/regpar5form_model.dart';

class Regpar5FormAPI {
  Future<ReturnDataAPI> regpar5FormTambahAPI(Regpar5FormModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar5form/create";
    Map<String, String> queryParams = {"modul_id": "regpar5FormTambahAPI"};
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

  Future<bool> regpar5FormUbahAPI(Regpar5FormModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar5form/update";
    Map<String, String> queryParams = {"modul_id": "regpar5FormUbahAPI"};

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

  Future<bool> regpar5FormHapusAPI(String regpar5Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar5form/delete";
    Map<String, String> queryParams = {
      'regpar5Id': regpar5Id,
      'modul_id': 'regpar5FormHapusAPI'
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

  Future<Regpar5FormModel> regpar5FormLihatAPI(String regpar1Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar5form/read";
    Map<String, String> queryParams = {'regpar1Id': regpar1Id};
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
      var returnData = Regpar5FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }

  Future<Regpar5FormModel> regpar5FormHitungPremiAPI(String regpar1Id) async {
    final String endpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar5form/hitungpremi";

    final queryParams = {
      'regpar1Id': regpar1Id,
      'modul_id': 'regpar5FormHitungPremiAPI',
    };

    final uri = AppData.uriHtpp(
      AppData.httpAuthority,
      endpoint,
      queryParams,
    );

    // 🔥 DEBUG REQUEST
    debugPrint("REQUEST => $uri");

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${AppData.userToken}',
        'Accept': 'application/json',
      },
    );

    // 🔥 DEBUG RESPONSE
    debugPrint("RESPONSE BODY => ${response.body}");

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      final json = jsonDecode(response.body);
      return Regpar5FormModel.fromJson(json);
    } else {
      throw Exception(
        'Hitung premi gagal: ${response.statusCode} ${response.body}',
      );
    }
  }
}
