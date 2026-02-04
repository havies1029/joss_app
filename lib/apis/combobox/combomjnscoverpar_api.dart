// import 'dart:convert';
// import 'package:joss_app/common/app_data.dart';
// import 'package:http/http.dart' as http;
// import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
//
// class ComboMJnscoverParAPI {
//
// 	Future<List<ComboMJnscoverParModel>> getComboMJnscoverParAPI() async {
// 		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mjnscoverparcombobox/getlist";
//
// 		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint);
// 		final http.Response response = await http.get(uri, headers: <String, String>{
// 			'Content-Type': 'application/json; odata=verbos',
// 			'Accept': 'application/json; odata=verbos',
// 			'Authorization': 'Bearer ${AppData.userToken}'
// 		});
//
// 		if (response.statusCode == 200) {
// 			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
// 			return parsed
// 				.map<ComboMJnscoverParModel>((json) => ComboMJnscoverParModel.fromJson(json))
// 				.toList();
// 		} else {
// 			throw Exception("Failed to load data");
// 		}
// 	}
// }


import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';

class ComboMJnscoverParAPI {

	Future<List<ComboMJnscoverParModel>> getComboMJnscoverParAPI() async {
		String urlGetComboEndPoint =
				"${AppData.prefixEndPoint}/api/mjnscoverparcombobox/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint);

		debugPrint("=== getComboMJnscoverParAPI ===");
		debugPrint("URL: $uri");
		debugPrint("Token: ${AppData.userToken.substring(0, 10)}..."); // potong token biar aman

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		debugPrint("Status Code: ${response.statusCode}");
		debugPrint("Response Body (raw): ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			debugPrint("Parsed length: ${parsed.length}");

			final result = parsed
					.map<ComboMJnscoverParModel>(
							(json) => ComboMJnscoverParModel.fromJson(json))
					.toList();

			debugPrint("Mapping success: ${result.length} items");

			return result;
		} else {
			debugPrint("ERROR Response: ${response.body}");
			throw Exception("Failed to load data. Status: ${response.statusCode}");
		}
	}

}