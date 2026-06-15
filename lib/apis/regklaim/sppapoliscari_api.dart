import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regklaim/sppapoliscari_model.dart';

class SppapoliscariAPI {
	Future<List<SppapoliscariModel>> getSppapoliscariAPI(
			String cobKlaimId,
			String searchText,
			) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/regklaim/sppapoliscari/getlist";

		Map<String, String> queryParams = {
			"cobKlaimId": cobKlaimId,
			"searchText": searchText,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		debugPrint("🔎 SPPAPOLIS URL: $uri");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		debugPrint("🔎 SPPAPOLIS STATUS: ${response.statusCode}");
		debugPrint("🔎 SPPAPOLIS BODY: ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			for (final item in parsed) {
				debugPrint("========== SPPAPOLIS ITEM ==========");
				debugPrint("polisNo   : [${item['polisNo']}]");
				debugPrint("sppaId    : [${item['sppaId']}]");
				debugPrint("sppaNoRef : [${item['sppaNoRef']}]");
				debugPrint("cobNama   : [${item['cobNama']}]");
				debugPrint("objectDesc: [${item['objectDesc']}]");
			}

			return parsed
					.map<SppapoliscariModel>((json) => SppapoliscariModel.fromJson(json))
					.toList();
		} else {
			debugPrint("❌ API ERROR: ${response.statusCode}");
			debugPrint("❌ API BODY: ${response.body}");
			throw Exception("Failed to load data");
		}
	}
}