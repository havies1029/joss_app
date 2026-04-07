//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimpar/klaimparklaimcrud_model.dart';

class KlaimparklaimcrudAPI {

	Future<ReturnDataAPI> klaimparklaimcrudTambahAPI(KlaimparklaimcrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/perbaruiklaimpar/klaimparklaimcrud/create";
		Map<String, String> queryParams = {"modul_id": "klaimparklaimcrudTambahAPI"};
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
	Future<bool> klaimparklaimcrudUbahAPI(KlaimparklaimcrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/perbaruiklaimpar/klaimparklaimcrud/update";
		Map<String, String> queryParams = {"modul_id": "klaimparklaimcrudUbahAPI"};

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
	Future<bool> klaimparklaimcrudHapusAPI(String klaim1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/perbaruiklaimpar/klaimparklaimcrud/delete";
		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
			'modul_id': 'klaimparklaimcrudHapusAPI'};
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
	Future<KlaimparklaimcrudModel?> klaimparklaimcrudLihatAPI(String klaim1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/perbaruiklaimpar/klaimparklaimcrud/read";
		Map<String, String> queryParams = {'klaim1Id': klaim1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

		debugPrint("===== [API CALL] klaimparklaimcrudLihatAPI =====");
		debugPrint("URL       : $uri");
		debugPrint("klaim1Id  : $klaim1Id");

		try {
			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
			);

			debugPrint("----- [RESPONSE] -----");
			debugPrint("Status Code : ${response.statusCode}");
			debugPrint("Body Raw    : ${response.body}");

			if (response.statusCode == 200) {
				final json = jsonDecode(response.body);

				debugPrint("Parsed JSON : $json");

				var returnData = KlaimparklaimcrudModel.fromJson(json);

				debugPrint("Parsed Model (laporAsuransi): ${returnData.laporAsuransi}");
				debugPrint("Parsed Model (isPolisJps)   : ${returnData.isPolisJps}");

				return returnData;
			}

			if (response.statusCode == 404) {
				debugPrint("Result: DATA NOT FOUND (404)");
				return null;
			}

			debugPrint("ERROR RESPONSE: ${response.body}");
			throw HttpException('HTTP ${response.statusCode}: ${response.body}');
		} catch (e, stack) {
			debugPrint("!!!!! ERROR klaimparklaimcrudLihatAPI !!!!!");
			debugPrint("Error : $e");
			debugPrint("Stack : $stack");
			throw Exception("Failed to load data: $e");
		}
	}
}
