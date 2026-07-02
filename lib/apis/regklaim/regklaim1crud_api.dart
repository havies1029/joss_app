import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regklaim/regklaim1crud_model.dart';

class Regklaim1CrudAPI {

	Future<ReturnDataAPI> regklaim1CrudTambahAPI(
			Regklaim1CrudModel record,
			) async {
		try {
			String tambahEndpoint =
					"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/create";

			Map<String, String> queryParams = {
				"modul_id": "regklaim1CrudTambahAPI",
			};

			var uri = AppData.uriHtpp(
				AppData.httpAuthority,
				tambahEndpoint,
				queryParams,
			);

			final requestBody = jsonEncode(record.toJson());

			debugPrint(
				"================ REGKLAIM CREATE REQUEST ================",
			);
			debugPrint("Endpoint : $tambahEndpoint");
			debugPrint("URI      : $uri");
			debugPrint("Params   : $queryParams");
			debugPrint("Body     : $requestBody");
			debugPrint(
				"========================================================",
			);

			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: requestBody,
			);

			debugPrint(
				"================ REGKLAIM CREATE RESPONSE ===============",
			);
			debugPrint("Status Code : ${response.statusCode}");
			debugPrint("Response    : ${response.body}");
			debugPrint(
				"========================================================",
			);

			if (response.statusCode == 200) {
				return ReturnDataAPI.fromDatabaseJson(
					jsonDecode(response.body),
				);
			} else {
				debugPrint(
					"REGKLAIM CREATE FAILED => Status ${response.statusCode}",
				);

				return ReturnDataAPI(
					success: false,
					data: "",
					rowcount: 0,
				);
			}
		} catch (e, stackTrace) {
			debugPrint(
				"================ REGKLAIM CREATE ERROR =================",
			);
			debugPrint("Error      : $e");
			debugPrint("StackTrace : $stackTrace");
			debugPrint(
				"========================================================",
			);

			return ReturnDataAPI(
				success: false,
				data: "",
				rowcount: 0,
			);
		}
	}

	Future<ReturnDataAPI> regklaim1Tambah4PolisJpsAPI(
			String sppa1Id,
			String mjenisrugimvId,
			String keterangan,
			) async {
		try {
			String lihatEndpoint =
					"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/create4polisjps";

			Map<String, String> queryParams = {
				'sppa1Id': sppa1Id,
				'mjenisrugimvId': mjenisrugimvId,
				'keterangan': keterangan,
				'modul_id': 'regklaim1Tambah4PolisJpsAPI',
			};

			var uri = AppData.uriHtpp(
				AppData.httpAuthority,
				lihatEndpoint,
				queryParams,
			);

			final headers = <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			};

			debugPrint(
					'================ REGKLAIM1 TAMBAH 4 POLIS JPS REQUEST ================');
			debugPrint('ENDPOINT    : $lihatEndpoint');
			debugPrint('QUERY PARAM : $queryParams');
			debugPrint('URL         : $uri');
			debugPrint('HEADERS     : $headers');

			final http.Response response = await http.get(
				uri,
				headers: headers,
			);

			debugPrint(
					'================ REGKLAIM1 TAMBAH 4 POLIS JPS RESPONSE ================');
			debugPrint('STATUS CODE : ${response.statusCode}');
			debugPrint('BODY        : ${response.body}');

			if (response.statusCode == 200) {
				final result = ReturnDataAPI.fromDatabaseJson(
					jsonDecode(response.body),
				);

				debugPrint(
						'================ REGKLAIM1 TAMBAH 4 POLIS JPS SUCCESS ================');
				debugPrint('SUCCESS     : ${result.success}');
				debugPrint('DATA        : ${result.data}');
				debugPrint('ROWCOUNT    : ${result.rowcount}');

				return result;
			} else {
				debugPrint(
						'================ REGKLAIM1 TAMBAH 4 POLIS JPS FAILED ================');
				debugPrint('STATUS CODE : ${response.statusCode}');
				debugPrint('BODY        : ${response.body}');

				throw Exception(
					"Failed to load data. StatusCode=${response.statusCode}",
				);
			}
		} catch (e, stackTrace) {
			debugPrint(
					'================ REGKLAIM1 TAMBAH 4 POLIS JPS ERROR ================');
			debugPrint('ERROR       : $e');
			debugPrint('STACKTRACE  : $stackTrace');

			rethrow;
		}
	}

	Future<ReturnDataAPI> regklaimToKlaimAPI(String regklaim1Id) async {
		try {
			String lihatEndpoint =
					"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/regklaimtoklaim";

			Map<String, String> queryParams = {
				'regklaim1Id': regklaim1Id,
				'modul_id': 'regklaimToKlaimAPI'
			};

			var uri =
			AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);

			debugPrint("========== regklaimToKlaimAPI REQUEST ==========");
			debugPrint("URL      : $uri");
			debugPrint("Method   : GET");
			debugPrint("Params   : $queryParams");
			debugPrint("Token    : ${AppData.userToken}");
			debugPrint("===============================================");

			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
			);

			debugPrint("========== regklaimToKlaimAPI RESPONSE =========");
			debugPrint("Status   : ${response.statusCode}");
			debugPrint("Body     : ${response.body}");
			debugPrint("================================================");

			if (response.statusCode == 200) {
				return ReturnDataAPI.fromDatabaseJson(
					jsonDecode(response.body),
				);
			} else {
				debugPrint(
					"regklaimToKlaimAPI ERROR : Status Code ${response.statusCode}",
				);
				throw Exception(
					"Failed to load data. Status Code : ${response.statusCode}",
				);
			}
		} catch (e, s) {
			debugPrint("========== regklaimToKlaimAPI EXCEPTION ========");
			debugPrint("Error    : $e");
			debugPrint("Stack    : $s");
			debugPrint("================================================");

			rethrow;
		}
	}
	Future<bool> regklaim1CrudUbahAPI(Regklaim1CrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regklaim/regklaim1crud/update";

		Map<String, String> queryParams = {
			"modul_id": "regklaim1CrudUbahAPI",
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			ubahEndpoint,
			queryParams,
		);

		final requestBody = jsonEncode(record.toJson());

		try {
			debugPrint("========== regklaim1CrudUbahAPI REQUEST ==========");
			debugPrint("URL: $uri");
			debugPrint("Endpoint: $ubahEndpoint");
			debugPrint("Query Params: $queryParams");
			debugPrint("Request Body: $requestBody");
			debugPrint("Token exists: ${AppData.userToken.isNotEmpty}");
			debugPrint("===================================================");

			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: requestBody,
			);

			debugPrint("========== regklaim1CrudUbahAPI RESPONSE ==========");
			debugPrint("Status Code: ${response.statusCode}");
			debugPrint("Response Body: ${response.body}");
			debugPrint("====================================================");

			ReturnDataAPI returnData;

			if (response.statusCode == 200) {
				try {
					returnData = ReturnDataAPI.fromDatabaseJson(
						jsonDecode(response.body),
					);

					debugPrint("========== regklaim1CrudUbahAPI PARSED ==========");
					debugPrint("Parsed success: ${returnData.success}");
					debugPrint("Parsed data: ${returnData.data}");
					debugPrint("Parsed rowcount: ${returnData.rowcount}");
					debugPrint("==================================================");
				} catch (e, stackTrace) {
					debugPrint("========== regklaim1CrudUbahAPI PARSE ERROR ==========");
					debugPrint("Parse Error: $e");
					debugPrint("StackTrace: $stackTrace");
					debugPrint("Raw Response Body: ${response.body}");
					debugPrint("=======================================================");

					returnData = ReturnDataAPI(
						success: false,
						data: "",
						rowcount: 0,
					);
				}
			} else {
				debugPrint("========== regklaim1CrudUbahAPI HTTP ERROR ==========");
				debugPrint("HTTP Error Status: ${response.statusCode}");
				debugPrint("HTTP Error Body: ${response.body}");
				debugPrint("=====================================================");

				returnData = ReturnDataAPI(
					success: false,
					data: "",
					rowcount: 0,
				);
			}

			return returnData.success;
		} catch (e, stackTrace) {
			debugPrint("========== regklaim1CrudUbahAPI EXCEPTION ==========");
			debugPrint("Exception: $e");
			debugPrint("StackTrace: $stackTrace");
			debugPrint("Request URL: $uri");
			debugPrint("Request Body: $requestBody");
			debugPrint("====================================================");

			return false;
		}
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
