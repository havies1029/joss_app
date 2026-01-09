import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/reguser/reguser_model.dart';

class RegUserAPI {

	Future<ReturnDataAPI> regUserTambahAPI(RegUserModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/reguser/create";
		Map<String, String> queryParams = {"modul_id": "regUserTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

    debugPrint("emailVerificationTambahAPI #10");
    debugPrint("URI: $uri");
    debugPrint("Request Body: ${jsonEncode(record.toJson())}");
    debugPrint("AppData.userToken: ${AppData.userToken}");

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
			body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}
	Future<bool> regUserUbahAPI(RegUserModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/reguser/update";
		Map<String, String> queryParams = {"modul_id": "regUserUbahAPI"};

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
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<bool> regUserHapusAPI(String reguserId) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/reguser/delete";
		Map<String, String> queryParams = {
			'reguserId': reguserId,
			'modul_id': 'regUserHapusAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<RegUserModel> regUserLihatAPI(String reguserId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/reguser/read";
		Map<String, String> queryParams = {'reguserId': reguserId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = RegUserModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<ReturnDataAPI> validasiPinHP(RegUserModel record, String requestFrom) async {
    String endpoint = "${AppData.prefixEndPoint}/api/reguser/validasipin";
    Map<String, String> queryParams = {"requiredFrom": "", "modul_id": "validasiPinHP"};
    var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    final http.Response response = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}'
      },
      body: jsonEncode(record.toJson()));

    if (response.statusCode == 200) {
      return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      return ReturnDataAPI(success: false, data: "", rowcount: 0);
    }
  } 
}
