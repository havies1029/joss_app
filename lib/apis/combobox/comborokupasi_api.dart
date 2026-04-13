import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class ComboROkupasiAPI {

	Future<List<ComboROkupasiModel>> getComboROkupasiAPI(String filter) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/rokupasicombobox/getlist";
		Map<String, String> queryParams = {"filter": filter};

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);

		final headers = <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		debugPrint("=== REQUEST ===");
		debugPrint("URL: $uri");
		debugPrint("METHOD: GET");
		debugPrint("HEADERS: $headers");
		debugPrint("QUERY PARAMS: $queryParams");

		final http.Response response = await http.get(uri, headers: headers);

		debugPrint("=== RESPONSE ===");
		debugPrint("STATUS: ${response.statusCode}");
		debugPrint("BODY:");
		debugPrint(response.body, wrapWidth: 1024);

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<ComboROkupasiModel>((json) => ComboROkupasiModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
