import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/login/emailverification_model.dart';

class EmailVerificationAPI {
	Future<ReturnDataAPI> emailVerificationTambahAPI(
			EmailVerificationModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/login/emailverification/create";
		Map<String, String> queryParams = {"modul_id": "emailVerificationTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		// 🔍 DEBUG LOG
		print("📤 [emailVerificationTambahAPI]");
		print("→ URI: $uri");
		print("→ Request Body: ${jsonEncode(record.toJson())}");

		ReturnDataAPI returnData;
		final http.Response response = await http.post(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
			},
			body: jsonEncode(record.toJson()),
		);

		print("📥 Response Status: ${response.statusCode}");
		print("📥 Raw Response Body: ${response.body}");

		if (response.statusCode == 200) {
			final decoded = jsonDecode(response.body);
			print("🧩 ReturnDataAPI JSON: $decoded"); // 🔥 log sebelum parse
			returnData = ReturnDataAPI.fromDatabaseJson(decoded);
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}

		print("✅ Final ReturnData: success=${returnData.success}, data=${returnData.data}, rowcount=${returnData.rowcount}");
		return returnData;
	}

	Future<ReturnDataAPI> validasiPinEmailAPI(
			EmailVerificationModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/login/emailverification/validasipinemail";
		Map<String, String> queryParams = {"modul_id": "validasiPinEmailAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		print("📤 [validasiPinEmailAPI]");
		print("→ URI: $uri");
		print("→ Request Body: ${jsonEncode(record.toJson())}");

		ReturnDataAPI returnData;
		final http.Response response = await http.post(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
			},
			body: jsonEncode(record.toJson()),
		);

		print("📥 Response Status: ${response.statusCode}");
		print("📥 Raw Response Body: ${response.body}");

		if (response.statusCode == 200) {
			final decoded = jsonDecode(response.body);
			print("🧩 ReturnDataAPI JSON: $decoded");
			returnData = ReturnDataAPI.fromDatabaseJson(decoded);
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}

		print("✅ Final ReturnData: success=${returnData.success}, data=${returnData.data}, rowcount=${returnData.rowcount}");
		return returnData;
	}
}
