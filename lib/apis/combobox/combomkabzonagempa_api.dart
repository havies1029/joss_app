import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';

class ComboMKabZonaGempaAPI {

	Future<List<ComboMKabZonaGempaModel>> getComboMKabZonaGempaAPI(
			String wilayahId, String searchText) async {

		String urlGetComboEndPoint =
				"${AppData.prefixEndPoint}/api/mkabzonagempacombobox/getlist";

		Map<String, String> queryParams = {
			"wilayahId": wilayahId,
			"searchText": searchText
		};

		var uri = AppData.uriHtpp(
				AppData.httpAuthority, urlGetComboEndPoint, queryParams);

		// 🔥 REQUEST DEBUG
		debugPrint("===== REQUEST =====");
		debugPrint("URL: $uri");
		debugPrint("wilayahId: $wilayahId");
		debugPrint("searchText: $searchText");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbose',
				'Accept': 'application/json; odata=verbose',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		// 🔥 RESPONSE DEBUG
		debugPrint("===== RESPONSE =====");
		debugPrint("Status Code: ${response.statusCode}");
		debugPrint("Body: ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			// 🔥 PARSED DEBUG
			debugPrint("===== PARSED =====");
			debugPrint(parsed.toString());

			return parsed
					.map<ComboMKabZonaGempaModel>(
							(json) => ComboMKabZonaGempaModel.fromJson(json))
					.toList();
		} else {
			debugPrint("===== ERROR =====");
			debugPrint(response.body);
			throw Exception("Failed to load data");
		}
	}
}
