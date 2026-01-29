import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

import '../../models/gen_regmv/regmv2form_model.dart';

class Regmv2FormAPI {

	Future<ReturnDataAPI> regmv2FormTambahAPI(Regmv2FormModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv2form/create";
		Map<String, String> queryParams = {"modul_id": "regmv2FormTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

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
	Future<bool> regmv2FormUbahAPI(Regmv2FormModel record) async {
		final ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv2form/update";
		final queryParams = {"modul_id": "regmv2FormUbahAPI"};

		final uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

		// 1) Build payload once
		final payloadMap = record.toJson();

		// 2) Encode once
		final payloadJson = jsonEncode(payloadMap);

		// 3) DEBUG payload yang bener-bener dikirim
		debugPrint("=== REGMV2 UBAH REQUEST ===");
		debugPrint("URI: $uri");
		debugPrint("Headers: {Content-Type: application/json, Accept: application/json, Authorization: Bearer ***}");
		debugPrint("Body JSON: $payloadJson");
		debugPrint("===========================");

		// Bonus: fokus ke field tanggal saja (biar gampang kebaca)
		debugPrint("=== DATE FIELDS (as JSON map) ===");
		debugPrint("polisMulai : ${payloadMap['polisMulai']}");
		debugPrint("polisAkhir : ${payloadMap['polisAkhir']}");
		debugPrint("=================================");

		final response = await http.post(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
			body: payloadJson,
		);

		// DEBUG response juga sekalian (biar tau BE bales apa)
		debugPrint("=== REGMV2 UBAH RESPONSE ===");
		debugPrint("Status: ${response.statusCode}");
		debugPrint("Body  : ${response.body}");
		debugPrint("============================");

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}

	Future<bool> regmv2FormHapusAPI(String regmv1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/regmv/regmv2form/delete";
		Map<String, String> queryParams = {
			'regmv1Id': regmv1Id,
			'modul_id': 'regmv2FormHapusAPI'};
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
	Future<Regmv2FormModel> regmv2FormLihatAPI(String regmv1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regmv/regmv2form/read";
		Map<String, String> queryParams = {'regmv1Id': regmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Regmv2FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
