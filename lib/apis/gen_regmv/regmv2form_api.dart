import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';

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
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv2form/update";
		Map<String, String> queryParams = {"modul_id": "regmv2FormUbahAPI"};

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

		debugPrint("🟦================ REGMV2 FORM LIHAT START ================");
		debugPrint("🔗 Endpoint       : $lihatEndpoint");
		debugPrint("🌐 Authority      : ${AppData.httpAuthority}");
		debugPrint("📌 Query Params   : $queryParams");
		debugPrint("➡️ Final URI      : $uri");

		// Token censor 80% biar aman
		final token = AppData.userToken ?? "";
		final safeToken = token.length > 10
				? token.substring(0, 6) + "..." + token.substring(token.length - 4)
				: token;

		final headers = <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		debugPrint("🧾 Headers        :");
		headers.forEach((k, v) {
			if (k == 'Authorization') {
				debugPrint("    $k: Bearer $safeToken");
			} else {
				debugPrint("    $k: $v");
			}
		});

		debugPrint("📤 Sending GET request...");

		final http.Response response = await http.get(uri, headers: headers);

		debugPrint("📥 Response Status: ${response.statusCode}");

		if (response.statusCode == 200) {
			debugPrint("📦 Raw Response Body:");
			debugPrint(response.body);

			try {
				var json = jsonDecode(response.body);
				debugPrint("📚 JSON Parsed Successfully.");

				var model = Regmv2FormModel.fromJson(json);
				debugPrint("✅ Model Parsed: ${model.toString()}");

				debugPrint("🟩=============== REGMV2 FORM LIHAT END =================");
				return model;
			} catch (e) {
				debugPrint("❌ JSON Parsing Error: $e");
				throw Exception("Failed to parse JSON: $e");
			}
		} else {
			debugPrint("❌ ERROR Status Code: ${response.statusCode}");
			debugPrint("❌ ERROR Body       : ${response.body}");
			debugPrint("🟥=============== REGMV2 FORM LIHAT FAILED ===============");
			throw Exception("Failed to load data: ${response.statusCode}");
		}
	}

}
