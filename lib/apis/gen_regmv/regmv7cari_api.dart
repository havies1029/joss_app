import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_regmv/regmv7cari_model.dart';

class Regmv7CariAPI{
	Future<List<Regmv7CariModel>> getRegmv7CariAPI(String regmv1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regmv/regmv7cari/getlist";
		Map<String, String> queryParams = {"regmv1Id": regmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);
		String previewBody = response.body.length > 300
				? "${response.body.substring(0, 300)}..."
				: response.body;

		debugPrint("📄 Response Preview: $previewBody");

		// HANDLE 200 OK
		if (response.statusCode == 200) {
			debugPrint("🟢 API SUCCESS — mulai parsing");

			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			debugPrint("📦 Parsed JSON count = ${parsed.length}");

			final list = parsed
					.map<Regmv7CariModel>((json) => Regmv7CariModel.fromJson(json))
					.toList();

			debugPrint("📋 Final Model Count = ${list.length}");
			debugPrint("✅ getRegmv7CariAPI DONE");
			debugPrint("============================================");

			return list;
		}

		// HANDLE NON-200
		debugPrint("❌ API ERROR — statusCode = ${response.statusCode}");
		debugPrint("❌ Body: ${response.body}");
		debugPrint("============================================");

		throw Exception("Failed to load data (status: ${response.statusCode})");
	}

}
