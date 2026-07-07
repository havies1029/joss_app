import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_profile/mrekanpiclist_model.dart';

class MRekanPicListAPI{
	Future<List<MRekanPicListModel>> getMRekanPicListAPI() async {
		try {
			String urlGetListEndPoint =
					"${AppData.prefixEndPoint}/api/profile/mrekanpiclist/getlist";

			var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);

			final headers = <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			};

			// ===== REQUEST =====
			debugPrint("========== GET REQUEST ==========");
			debugPrint("URL     : $uri");
			debugPrint("Headers : $headers");

			final http.Response response = await http.get(
				uri,
				headers: headers,
			);

			// ===== RESPONSE =====
			debugPrint("========== GET RESPONSE ==========");
			debugPrint("Status Code : ${response.statusCode}");
			debugPrint("Body        : ${response.body}");

			if (response.statusCode == 200) {
				final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

				debugPrint("Total Data : ${parsed.length}");

				return parsed
						.map<MRekanPicListModel>(
								(json) => MRekanPicListModel.fromJson(json))
						.toList();
			} else {
				debugPrint("========== API ERROR ==========");
				debugPrint("Status Code : ${response.statusCode}");
				debugPrint("Response    : ${response.body}");

				throw Exception(
						"Failed to load data. Status: ${response.statusCode}");
			}
		} catch (e, stackTrace) {
			debugPrint("========== EXCEPTION ==========");
			debugPrint("Error      : $e");
			debugPrint("StackTrace : $stackTrace");

			rethrow;
		}
	}
}
