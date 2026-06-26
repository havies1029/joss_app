//generate from : lib/apis/perbaruiklaimmv/klaimmvklaimcrud_api.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvklaimcrud_model.dart';

class KlaimmvklaimcrudAPI {

	Future<ReturnDataAPI> klaimmvklaimcrudTambahAPI(
			KlaimmvklaimcrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvklaimcrud/create";

		Map<String, String> queryParams = {
			"modul_id": "klaimmvklaimcrudTambahAPI"
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			tambahEndpoint,
			queryParams,
		);

		try {
			debugPrint("========== Klaim MV Klaim Tambah API ==========");
			debugPrint("REQUEST METHOD  : POST");
			debugPrint("REQUEST URL     : $uri");
			debugPrint("REQUEST PARAMS  : $queryParams");
			debugPrint("REQUEST BODY    : ${jsonEncode(record.toJson())}");

			final stopwatch = Stopwatch()..start();

			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()),
			);

			stopwatch.stop();

			debugPrint("STATUS CODE     : ${response.statusCode}");
			debugPrint("ELAPSED TIME    : ${stopwatch.elapsedMilliseconds} ms");
			debugPrint("RESPONSE BODY   : ${response.body}");
			debugPrint("===============================================");

			ReturnDataAPI returnData;

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				returnData =
						ReturnDataAPI(success: false, data: "", rowcount: 0);
			}

			return returnData;
		} catch (e, stackTrace) {
			debugPrint("========== Klaim MV Klaim Tambah API ERROR ==========");
			debugPrint("REQUEST URL     : $uri");
			debugPrint("REQUEST PARAMS  : $queryParams");
			debugPrint("REQUEST BODY    : ${jsonEncode(record.toJson())}");
			debugPrint("ERROR           : $e");
			debugPrint("STACKTRACE      :");
			debugPrint(stackTrace.toString());
			debugPrint("====================================================");

			rethrow;
		}
	}
	Future<bool> klaimmvklaimcrudUbahAPI(KlaimmvklaimcrudModel record) async {
		try {
			String ubahEndpoint =
					"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvklaimcrud/update";
			Map<String, String> queryParams = {
				"modul_id": "klaimmvklaimcrudUbahAPI"
			};

			var uri =
			AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

			final headers = <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			};

			final body = jsonEncode(record.toJson());

			debugPrint("========== klaimmvklaimcrudUbahAPI ==========");
			debugPrint("REQUEST URL:");
			debugPrint(uri.toString());

			debugPrint("REQUEST HEADER:");
			debugPrint(headers.toString());

			debugPrint("REQUEST BODY:");
			debugPrint(body);

			final http.Response response = await http.post(
				uri,
				headers: headers,
				body: body,
			);

			debugPrint("STATUS CODE:");
			debugPrint(response.statusCode.toString());

			debugPrint("RESPONSE BODY:");
			debugPrint(response.body);

			ReturnDataAPI returnData;
			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));

				debugPrint("SUCCESS : ${returnData.success}");
				debugPrint("DATA    : ${returnData.data}");
				debugPrint("ROWCOUNT: ${returnData.rowcount}");
			} else {
				debugPrint("HTTP ERROR: ${response.statusCode}");

				returnData = ReturnDataAPI(
					success: false,
					data: "",
					rowcount: 0,
				);
			}

			debugPrint("============================================");

			return returnData.success;
		} catch (e, stackTrace) {
			debugPrint("========== klaimmvklaimcrudUbahAPI ERROR ==========");
			debugPrint("ERROR:");
			debugPrint(e.toString());

			debugPrint("STACKTRACE:");
			debugPrint(stackTrace.toString());

			debugPrint("==================================================");

			return false;
		}
	}
	Future<bool> klaimmvklaimcrudHapusAPI(String klaim1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvklaimcrud/delete";
		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
			'modul_id': 'klaimmvklaimcrudHapusAPI'};
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
	Future<KlaimmvklaimcrudModel?> klaimmvklaimcrudLihatAPI(String klaim1Id) async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvklaimcrud/read";

		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			lihatEndpoint,
			queryParams,
		);

		try {
			debugPrint("========== Klaim MV Lihat API ==========");
			debugPrint("REQUEST URL     : $uri");
			debugPrint("REQUEST PARAMS  : $queryParams");
			debugPrint("REQUEST METHOD  : GET");
			debugPrint(
				"REQUEST HEADERS : {"
						"'Content-Type': 'application/json; odata=verbos', "
						"'Accept': 'application/json; odata=verbos', "
						"'Authorization': 'Bearer ${AppData.userToken.substring(0, 20)}...'"
						"}",
			);

			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
			);

			debugPrint("STATUS CODE     : ${response.statusCode}");
			debugPrint("RESPONSE BODY   : ${response.body}");
			debugPrint("========================================");

			if (response.statusCode == 200) {
				return KlaimmvklaimcrudModel.fromJson(
					jsonDecode(response.body),
				);
			}

			if (response.statusCode == 404) {
				debugPrint("Data tidak ditemukan (404)");
				return null;
			}

			throw HttpException(
				"HTTP ${response.statusCode}: ${response.body}",
			);
		} catch (e, stackTrace) {
			debugPrint("========== API ERROR ==========");
			debugPrint("URL        : $uri");
			debugPrint("ERROR      : $e");
			debugPrint("STACKTRACE :");
			debugPrint(stackTrace.toString());
			debugPrint("===============================");

			throw Exception("Failed to load data: $e");
		}
	}
}
