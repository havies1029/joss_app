import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regklaim/sppapoliscari_model.dart';

class SppapoliscariAPI{
	Future<List<SppapoliscariModel>> getSppapoliscariAPI(
			String cobKlaimId, String searchText, int hal) async {

		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/regklaim/sppapoliscari/getlist";

		Map<String, String> queryParams = {
			"cobKlaimId": cobKlaimId,
			"searchText": searchText,
			"hal": hal.toString()
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

		// 🔍 DEBUG REQUEST
		debugPrint("=== API CALL START ===");
		debugPrint("URL: $uri");
		debugPrint("Params: $queryParams");
		debugPrint("Token: ${AppData.userToken}");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		// 🔍 DEBUG RESPONSE
		debugPrint("Status Code: ${response.statusCode}");
		debugPrint("Response Body: ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			// 🔍 DEBUG PARSED RESULT
			debugPrint("Parsed length: ${parsed.length}");

			return parsed
					.map<SppapoliscariModel>((json) => SppapoliscariModel.fromJson(json))
					.toList();
		} else {
			// 🔥 ERROR DEBUG
			debugPrint("❌ API ERROR: ${response.statusCode}");
			throw Exception("Failed to load data");
		}
	}
}
