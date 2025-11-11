import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_aset_health/asethealthcari_model.dart';

class AsetHealthCariAPI{
	Future<List<AsetHealthCariModel>> getAsetHealthCariAPI(
			String statusId,
			String searchText,
			int hal,
			) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/assethealth/asethealthcari/getlist";

		Map<String, String> queryParams = {
			"statusId": statusId,
			"searchText": searchText,
			"hal": hal.toString(),
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

		// 🧩 Debug URL dan query-nya
		debugPrint("🟩 [API CALL] GET $uri");
		debugPrint("🔸 Headers: ${{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken.substring(0, 15)}...'
		}}");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		// 🧾 Log hasil response
		debugPrint("🟨 [API RESPONSE] Status: ${response.statusCode}");
		if (response.body.isNotEmpty) {
			debugPrint("🟦 [API RESPONSE BODY]: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}");
		} else {
			debugPrint("❗ [API RESPONSE] Body kosong");
		}

		if (response.statusCode == 200) {
			try {
				final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

				// 🧠 Debug jumlah data & sampel data pertama
				debugPrint("✅ [API SUCCESS] Parsed count: ${parsed.length}");
				if (parsed.isNotEmpty) {
					debugPrint("📦 Sample item: ${parsed.first}");
				}

				return parsed
						.map<AsetHealthCariModel>((json) => AsetHealthCariModel.fromJson(json))
						.toList();
			} catch (e, stack) {
				debugPrint("❌ [JSON PARSE ERROR]: $e");
				debugPrint(stack.toString());
				throw Exception("JSON parsing failed: $e");
			}
		} else {
			debugPrint("🚨 [HTTP ERROR ${response.statusCode}]: ${response.reasonPhrase}");
			throw Exception("Failed to load data (HTTP ${response.statusCode})");
		}
	}

}
