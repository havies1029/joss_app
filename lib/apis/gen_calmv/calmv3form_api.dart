import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';

class Calmv3FormAPI {
  Future<ReturnDataAPI> calmv3FormTambahAPI(Calmv3FormModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/calmv/calmv3form/create";
    Map<String, String> queryParams = {"modul_id": "calmv3FormTambahAPI"};
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

  Future<bool> calmv3FormUbahAPI(Calmv3FormModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/calmv/calmv3form/update";
    Map<String, String> queryParams = {"modul_id": "calmv3FormUbahAPI"};

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

  Future<bool> calmv3FormHapusAPI(String calmv3Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/calmv/calmv3form/delete";
    Map<String, String> queryParams = {
      'calmv3Id': calmv3Id,
      'modul_id': 'calmv3FormHapusAPI'
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

  Future<Calmv3FormModel> calmv3FormLihatAPI(String calmv1Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/calmv/calmv3form/read";
    Map<String, String> queryParams = {'calmv1Id': calmv1Id};
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
      var returnData = Calmv3FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }

  Future<Calmv3FormModel> calmv3FormHitungPremiAPI(String calmv1Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/calmv/calmv3form/hitungpremi";

    Map<String, String> queryParams = {
      'calmv1Id': calmv1Id,
      'modul_id': 'calmv3FormHitungPremiAPI',
    };

    var uri =
        AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

    // 🔍 DEBUG REQUEST
    debugPrint(
      "[API] Calmv3HitungPremi REQUEST\n"
      "URI: $uri",
    );

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    // 🔍 DEBUG RESPONSE
    debugPrint(
      "[API] Calmv3HitungPremi RESPONSE "
      "status=${response.statusCode} "
      "body=${response.body}",
    );

    if (response.statusCode == 200) {
      ApiSideEffects.refreshHakakses();
      var returnData = Calmv3FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      throw Exception(
        "Failed to load data hitung premi (status=${response.statusCode})",
      );
    }
  }
}
