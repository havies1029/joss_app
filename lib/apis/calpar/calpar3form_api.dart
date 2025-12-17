import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/calpar/calpar3form_model.dart';

class Calpar3FormAPI {

	Future<ReturnDataAPI> calpar3FormTambahAPI(Calpar3FormModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/calpar/calpar3form/create";
		Map<String, String> queryParams = {"modul_id": "calpar3FormTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		// 🔍 DEBUG — sebelum request
		debugPrint("=== [CALPAR3 CREATE] REQUEST ===");
		debugPrint("URL        : $uri");
		debugPrint("Headers    : ${{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}',
		}}");
		debugPrint("Body (json): ${jsonEncode(record.toJson())}");
		debugPrint("================================");

		ReturnDataAPI returnData;

		try {
			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: jsonEncode(record.toJson()),
			);

			// 🔍 DEBUG — setelah request
			debugPrint("=== [CALPAR3 CREATE] RESPONSE ===");
			debugPrint("StatusCode : ${response.statusCode}");
			debugPrint("Response   : ${response.body}");
			debugPrint("=================================");

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				returnData = ReturnDataAPI(
					success: false,
					data: response.body,
					rowcount: 0,
				);
			}
		} catch (e, stack) {
			// 🔥 DEBUG — jika terjadi error (misal timeout / no internet / parsing error)
			debugPrint("=== [CALPAR3 CREATE] ERROR ===");
			debugPrint("Error : $e");
			debugPrint("Stack : $stack");
			debugPrint("===============================");

			returnData = ReturnDataAPI(
				success: false,
				data: e.toString(),
				rowcount: 0,
			);
		}

		return returnData;
	}

	Future<bool> calpar3FormUbahAPI(Calpar3FormModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/calpar/calpar3form/update";
		Map<String, String> queryParams = {"modul_id": "calpar3FormUbahAPI"};

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
	Future<bool> calpar3FormHapusAPI(String calpar3Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calpar/calpar3form/delete";
		Map<String, String> queryParams = {
			'calpar3Id': calpar3Id,
			'modul_id': 'calpar3FormHapusAPI'};
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
	Future<Calpar3FormModel> calpar3FormLihatAPI(String calpar1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/calpar/calpar3form/read";
		Map<String, String> queryParams = {'calpar1Id': calpar1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Calpar3FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
