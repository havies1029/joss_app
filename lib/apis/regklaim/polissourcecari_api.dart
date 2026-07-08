import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regklaim/polissourcecari_model.dart';

class PolissourcecariAPI{
	Future<List<PolissourcecariModel>> getPolissourcecariAPI() async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/regklaim/polissourcecari/getlist";

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
		);

		final headers = <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}',
		};

		// REQUEST
		debugPrint("========== REQUEST ==========");
		debugPrint("METHOD : GET");
		debugPrint("URL    : $uri");
		debugPrint("HEADERS: $headers");
		debugPrint("=============================");

		final http.Response response = await http.get(
			uri,
			headers: headers,
		);

		// RESPONSE
		debugPrint("========== RESPONSE ==========");
		debugPrint("STATUS : ${response.statusCode}");
		debugPrint("BODY   : ${response.body}");
		debugPrint("==============================");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			return parsed
					.map<PolissourcecariModel>(
						(json) => PolissourcecariModel.fromJson(json),
			)
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
