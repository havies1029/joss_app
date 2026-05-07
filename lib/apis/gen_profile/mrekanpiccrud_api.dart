import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';

class MRekanPicCrudAPI {

	Future<ReturnDataAPI> mRekanPicCrudTambahAPI(MRekanPicCrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/create";

		Map<String, String> queryParams = {
			"modul_id": "mRekanPicCrudTambahAPI"
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			tambahEndpoint,
			queryParams,
		);

		ReturnDataAPI returnData;

		try {
			final bodyJson = jsonEncode(record.toJson());

			debugPrint("=== API REQUEST : mRekanPicCrudTambahAPI ===");
			debugPrint("URL      : $uri");
			debugPrint("METHOD   : POST");
			debugPrint("HEADERS  : Authorization Bearer ${AppData.userToken}");
			debugPrint("BODY     : $bodyJson");

			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: bodyJson,
			);

			debugPrint("=== API RESPONSE : mRekanPicCrudTambahAPI ===");
			debugPrint("STATUS CODE : ${response.statusCode}");
			debugPrint("BODY        : ${response.body}");

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				debugPrint("API ERROR STATUS : ${response.statusCode}");

				returnData = ReturnDataAPI(
					success: false,
					data: "",
					rowcount: 0,
				);
			}
		} catch (e, stack) {
			debugPrint("=== API EXCEPTION : mRekanPicCrudTambahAPI ===");
			debugPrint("ERROR : $e");
			debugPrint("STACK : $stack");

			returnData = ReturnDataAPI(
				success: false,
				data: "",
				rowcount: 0,
			);
		}

		return returnData;
	}

	Future<bool> mRekanPicCrudUbahAPI(MRekanPicCrudModel record) async {
		final ubahEndpoint =
				"${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/update";

		final queryParams = {
			"modul_id": "mRekanPicCrudUbahAPI",
		};

		final uri = AppData.uriHtpp(
			AppData.httpAuthority,
			ubahEndpoint,
			queryParams,
		);

		try {
			final body = jsonEncode(record.toJson());

			debugPrint("🚀 [API CALL] mRekanPicCrudUbahAPI");
			debugPrint("📍 URI : $uri");
			debugPrint("📦 BODY : $body");

			final response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbose',
					'Accept': 'application/json; odata=verbose',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: body,
			);

			debugPrint("📡 STATUS CODE : ${response.statusCode}");
			debugPrint("📥 RESPONSE BODY : ${response.body}");

			if (response.statusCode != 200) {
				return false;
			}

			// Backend sekarang balikin body: null
			// Jadi anggap HTTP 200 sebagai sukses.
			if (response.body.trim().isEmpty || response.body.trim() == 'null') {
				return true;
			}

			final decoded = jsonDecode(response.body);

			if (decoded == null) {
				return true;
			}

			final returnData = ReturnDataAPI.fromDatabaseJson(decoded);

			debugPrint("✅ API SUCCESS : ${returnData.success}");

			return returnData.success;
		} catch (e, stackTrace) {
			debugPrint("❌ ERROR mRekanPicCrudUbahAPI : $e");
			debugPrint("📌 STACKTRACE : $stackTrace");
			return false;
		}
	}

	Future<bool> mRekanPicCrudHapusAPI(String mrekanpicId) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/delete";
		Map<String, String> queryParams = {
			'mrekanpicId': mrekanpicId,
			'modul_id': 'mRekanPicCrudHapusAPI'};
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

	Future<MRekanPicCrudModel> mRekanPicCrudLihatAPI(String mrekanpicId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/read";
		Map<String, String> queryParams = {'mrekanpicId': mrekanpicId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = MRekanPicCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
