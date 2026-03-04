//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvpoliscrud_model.dart';

class KlaimmvpoliscrudAPI {

	Future<ReturnDataAPI> klaimmvpoliscrudTambahAPI(
			KlaimmvpoliscrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/create";
		Map<String, String> queryParams = {"modul_id": "klaimmvpoliscrudTambahAPI"};
		var uri = AppData.uriHtpp(
				AppData.httpAuthority, tambahEndpoint, queryParams);

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

	Future<bool> klaimmvpoliscrudUbahAPI(KlaimmvpoliscrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/update";
		Map<String, String> queryParams = {"modul_id": "klaimmvpoliscrudUbahAPI"};

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

	Future<bool> klaimmvpoliscrudHapusAPI(String klaim1Id) async {
		String hapusEndpoint = "${AppData
				.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/delete";
		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
			'modul_id': 'klaimmvpoliscrudHapusAPI'};
		var uri = AppData.uriHtpp(
				AppData.httpAuthority, hapusEndpoint, queryParams);
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

	Future<KlaimmvpoliscrudModel?> klaimmvpoliscrudLihatAPI(
			String klaim1Id) async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvpoliscrud/read";

		Map<String, String> queryParams = {'klaim1Id': klaim1Id};

		var uri =
		AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

		try {
			// ===============================
			// DEBUG REQUEST
			// ===============================
			print("=== REQUEST ===");
			print("URL      : $uri");
			print("Method   : GET");
			print("Headers  :");
			print("  Content-Type : application/json");
			print("  Accept       : application/json");
			print("  Authorization: Bearer ${AppData.userToken}");
			print("klaim1Id : $klaim1Id");
			print("================");

			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json',
					'Accept': 'application/json',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
			);

			// ===============================
			// DEBUG RESPONSE
			// ===============================
			print("=== RESPONSE ===");
			print("Status Code : ${response.statusCode}");
			print("Body        : ${response.body}");
			print("================");

			if (response.statusCode == 200) {
				var returnData =
				KlaimmvpoliscrudModel.fromJson(jsonDecode(response.body));
				return returnData;
			}

			if (response.statusCode == 404) {
				print("Data tidak ditemukan (404)");
				return null;
			}

			throw HttpException(
					'HTTP ${response.statusCode}: ${response.body}');
		} catch (e, stackTrace) {
			print("=== ERROR ===");
			print(e);
			print(stackTrace);
			print("==============");

			throw Exception("Failed to load data: $e");
		}
	}
}