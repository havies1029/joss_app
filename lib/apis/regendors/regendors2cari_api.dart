import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regendors/regendors2cari_model.dart';

class Regendors2CariAPI {
	Future<List<Regendors2CariModel>> getRegendors2CariAPI(String regendors1Id) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/regendors/regendors2cari/getlist";

		Map<String, String> queryParams = {"regendors1Id": regendors1Id};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		debugPrint("📤 REQUEST URL: $uri");
		debugPrint("📤 QUERY PARAMS: $queryParams");
		debugPrint("📤 TOKEN: ${AppData.userToken}");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		debugPrint("📥 STATUS CODE: ${response.statusCode}");
		debugPrint("📥 RESPONSE BODY: ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			final result = parsed
					.map<Regendors2CariModel>(
							(json) => Regendors2CariModel.fromJson(json))
					.toList();

			debugPrint("✅ PARSED LENGTH: ${result.length}");

			return result;
		} else {
			debugPrint("❌ ERROR RESPONSE: ${response.body}");
			throw Exception("Failed to load data");
		}
	}
}

