import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regpar/regpar6form_model.dart';

class Regpar6FormAPI {
  Future<ReturnDataAPI> regpar6FormTambahAPI(Regpar6FormModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar6form/create";
    Map<String, String> queryParams = {"modul_id": "regpar6FormTambahAPI"};
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

  Future<bool> regpar6FormUbahAPI(Regpar6FormModel record) async {
    String ubahEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar6form/update";
    Map<String, String> queryParams = {"modul_id": "regpar6FormUbahAPI"};

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

  Future<bool> regpar6FormHapusAPI(String regpar6Id) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar6form/delete";
    Map<String, String> queryParams = {
      'regpar6Id': regpar6Id,
      'modul_id': 'regpar6FormHapusAPI'
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

  Future<Regpar6FormModel> regpar6FormLihatAPI(String regpar6Id) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/regpar/regpar6form/read";
    Map<String, String> queryParams = {'regpar6Id': regpar6Id};
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
      var returnData = Regpar6FormModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }
}
