import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regklaim/regklaim1crud_model.dart';

class Regklaim1CrudAPI {

	Future<ReturnDataAPI> regklaim1CrudTambahAPI(Regklaim1CrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/create";

		Map<String, String> queryParams = {
			"modul_id": "regklaim1CrudTambahAPI"
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		final requestBody = jsonEncode(record.toJson());

		// ================= REQUEST DEBUG =================
		debugPrint("========== REQUEST regklaim1CrudTambahAPI ==========");
		debugPrint("POST URI     : $uri");
		debugPrint("Headers      : Bearer ${AppData.userToken}");
		debugPrint("Body         : $requestBody");
		debugPrint("====================================================");

		final http.Response response = await http.post(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
			body: requestBody,
		);

		// ================= RESPONSE DEBUG =================
		debugPrint("========== RESPONSE regklaim1CrudTambahAPI ==========");
		debugPrint("Status Code  : ${response.statusCode}");
		debugPrint("Response Body: ${response.body}");
		debugPrint("====================================================");

		if (response.statusCode == 200) {
			return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			return ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
	}

	Future<ReturnDataAPI> regklaim1Tambah4PolisJpsAPI(String sppa1Id) async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/create4polisjps";

		Map<String, String> queryParams = {
			'sppa1Id': sppa1Id,
			'modul_id': 'regklaim1Tambah4PolisJpsAPI'
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

		// ================= REQUEST DEBUG =================
		debugPrint("========== REQUEST regklaim1Tambah4PolisJpsAPI ==========");
		debugPrint("GET URI      : $uri");
		debugPrint("sppa1Id      : $sppa1Id");
		debugPrint("=========================================================");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		// ================= RESPONSE DEBUG =================
		debugPrint("========== RESPONSE regklaim1Tambah4PolisJpsAPI ==========");
		debugPrint("Status Code  : ${response.statusCode}");
		debugPrint("Response Body: ${response.body}");
		debugPrint("==========================================================");

		if (response.statusCode == 200) {
			return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<ReturnDataAPI> regklaimToKlaimAPI(String regklaim1Id) async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/regklaimtoklaim";

		Map<String, String> queryParams = {
			'regklaim1Id': regklaim1Id,
			'modul_id': 'regklaimToKlaimAPI'
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

		// ================= REQUEST DEBUG =================
		debugPrint("========== REQUEST regklaimToKlaimAPI ==========");
		debugPrint("GET URI        : $uri");
		debugPrint("regklaim1Id    : $regklaim1Id");
		debugPrint("================================================");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		// ================= RESPONSE DEBUG =================
		debugPrint("========== RESPONSE regklaimToKlaimAPI ==========");
		debugPrint("Status Code  : ${response.statusCode}");
		debugPrint("Response Body: ${response.body}");
		debugPrint("================================================");

		if (response.statusCode == 200) {
			return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<bool> regklaim1CrudUbahAPI(Regklaim1CrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/update";
		Map<String, String> queryParams = {"modul_id": "regklaim1CrudUbahAPI"};

		var uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

		final requestBody = jsonEncode(record.toJson());

		// ================= REQUEST DEBUG =================
		debugPrint("========== REQUEST regklaim1CrudUbahAPI ==========");
		debugPrint("POST URI     : $uri");
		debugPrint("Headers      : Bearer ${AppData.userToken}");
		debugPrint("Body         : $requestBody");
		debugPrint("==================================================");

		final http.Response response = await http.post(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
			body: requestBody,
		);

		// ================= RESPONSE DEBUG =================
		debugPrint("========== RESPONSE regklaim1CrudUbahAPI ==========");
		debugPrint("Status Code  : ${response.statusCode}");
		debugPrint("Response Body: ${response.body}");
		debugPrint("===================================================");

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}

		// OPTIONAL: debug hasil parsing (biar jelas successnya dari mana)
		debugPrint("Parsed success: ${returnData.success}");

		return returnData.success;
	}

	Future<bool> regklaim1CrudHapusAPI(String regklaim1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/delete";
		Map<String, String> queryParams = {
			'regklaim1Id': regklaim1Id,
			'modul_id': 'regklaim1CrudHapusAPI'};
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
	Future<Regklaim1CrudModel> regklaim1CrudLihatAPI(String regklaim1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/read";
		Map<String, String> queryParams = {'regklaim1Id': regklaim1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Regklaim1CrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
