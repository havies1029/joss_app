import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combommvmodel_model.dart';

class ComboMMvmodelAPI {
	Future<List<ComboMMvmodelModel>> getComboMMvmodelAPI(String mvtipeId, String filter) async {
		// Debugging input parameters
		debugPrint("[ComboMMvmodelAPI] mvtipeId: $mvtipeId");
		debugPrint("[ComboMMvmodelAPI] filter before trim: $filter");

		// Set nilai default filter ke "" jika null atau kosong
		filter = filter.trim().isEmpty ?? true ? "" : filter;

		// Debug after normalizing filter
		debugPrint("[ComboMMvmodelAPI] filter after trim: $filter");

		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mmvmodelcombobox/getlist";

		// Memasukkan query parameters dengan filter yang sudah disesuaikan
		Map<String, String> queryParams = {"mvtipeId": mvtipeId, "filter": filter};

		// Debugging the full URL and query parameters
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		debugPrint("[ComboMMvmodelAPI] Full URI: $uri");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
		);

		// Debugging status code and body
		debugPrint("[ComboMMvmodelAPI] statusCode = ${response.statusCode}");
		debugPrint("[ComboMMvmodelAPI] response body = ${response.body}");

		if (response.statusCode == 200) {
			try {
				final decoded = json.decode(response.body);
				if (decoded is List) {
					debugPrint("[ComboMMvmodelAPI] decoded list length = ${decoded.length}");
					final parsed = decoded.cast<Map<String, dynamic>>();
					final result = parsed
							.map<ComboMMvmodelModel>((json) => ComboMMvmodelModel.fromJson(json))
							.toList();
					debugPrint("[ComboMMvmodelAPI] mapped models length = ${result.length}");
					return result;
				} else {
					debugPrint("[ComboMMvmodelAPI] WARNING: response bukan List: $decoded");
					return [];
				}
			} catch (e, st) {
				debugPrint("[ComboMMvmodelAPI] ERROR decode/mapping: $e");
				debugPrint(st.toString());
				return [];
			}
		} else {
			debugPrint("[ComboMMvmodelAPI] ERROR status != 200");
			throw Exception("Failed to load data");
		}
	}
}
