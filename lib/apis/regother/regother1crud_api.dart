import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';

class Regother1CrudAPI {

	Future<ReturnDataAPI> regother1CrudTambahAPI(Regother1CrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/regother/regother1crud/create";

		Map<String, String> queryParams = {"modul_id": "regother1CrudTambahAPI"};

		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		debugPrint("========== API REQUEST ==========");
		debugPrint("URL: $uri");
		debugPrint("BODY: ${jsonEncode(record.toJson())}");
		debugPrint("TOKEN: ${AppData.userToken}");

		ReturnDataAPI returnData;

		try {
			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()),
			);

			debugPrint("========== API RESPONSE ==========");
			debugPrint("STATUS CODE: ${response.statusCode}");
			debugPrint("BODY: ${response.body}");

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				debugPrint("API ERROR STATUS: ${response.statusCode}");
				returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
			}
		} catch (e, stack) {
			debugPrint("========== API EXCEPTION ==========");
			debugPrint("ERROR: $e");
			debugPrint("STACK: $stack");

			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}

		return returnData;
	}

	Future<bool> regother1CrudUbahAPI(Regother1CrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regother/regother1crud/update";
		Map<String, String> queryParams = {"modul_id": "regother1CrudUbahAPI"};

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
	Future<bool> regother1CrudHapusAPI(String regother1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/regother/regother1crud/delete";
		Map<String, String> queryParams = {
			'regother1Id': regother1Id,
			'modul_id': 'regother1CrudHapusAPI'};
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
	Future<Regother1CrudModel> regother1CrudLihatAPI(String regother1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regother/regother1crud/read";
		Map<String, String> queryParams = {'regother1Id': regother1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Regother1CrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
