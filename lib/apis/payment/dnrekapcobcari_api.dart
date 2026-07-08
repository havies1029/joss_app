import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

class DnrekapcobCariAPI{
	Future<List<DnrekapcobCariModel>> getDnrekapcobCariAPI() async {
		const String tag = "getDnrekapcobCariAPI";

		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/payment/dnrekapcobcari/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);

		final headers = <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}',
		};

		try {
			debugPrint("[$tag] REQUEST URL: $uri");
			debugPrint("[$tag] REQUEST METHOD: GET");
			debugPrint("[$tag] REQUEST HEADERS: {"
					"Content-Type: ${headers['Content-Type']}, "
					"Accept: ${headers['Accept']}, "
					"Authorization: Bearer ${AppData.userToken.isNotEmpty ? '***TOKEN_EXISTS***' : 'EMPTY'}"
					"}");

			final http.Response response = await http.get(
				uri,
				headers: headers,
			);

			debugPrint("[$tag] RESPONSE STATUS: ${response.statusCode}");
			debugPrint("[$tag] RESPONSE BODY: ${response.body}");

			if (response.statusCode == 200) {
				final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

				final result = parsed
						.map<DnrekapcobCariModel>(
							(json) => DnrekapcobCariModel.fromJson(json),
				)
						.toList();

				debugPrint("[$tag] PARSED ROW COUNT: ${result.length}");

				return result;
			} else {
				debugPrint("[$tag] ERROR RESPONSE STATUS: ${response.statusCode}");
				debugPrint("[$tag] ERROR RESPONSE BODY: ${response.body}");

				throw Exception(
					"Failed to load data. StatusCode: ${response.statusCode}, Body: ${response.body}",
				);
			}
		} catch (e, stackTrace) {
			debugPrint("[$tag] EXCEPTION: $e");
			debugPrint("[$tag] STACKTRACE: $stackTrace");

			rethrow;
		}
	}
}
