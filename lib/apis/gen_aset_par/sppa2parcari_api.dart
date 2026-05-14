import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_aset_par/sppa2parcari_model.dart';

class Sppa2parCariAPI{
	Future<List<Sppa2parCariModel>> getSppa2parCariAPI(
			String sppa1Id,
			String searchText,
			int hal,
			) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/assetpar/sppa2parcari/getlist";

		Map<String, String> queryParams = {
			"sppa1Id": sppa1Id,
			"searchText": searchText,
			"hal": hal.toString(),
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		final headers = <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}',
		};

		debugPrint("========== REQUEST ==========");
		debugPrint("URL      : $uri");
		debugPrint("METHOD   : GET");
		debugPrint("QUERY    : $queryParams");
		debugPrint("HEADERS  : $headers");

		try {
			final http.Response response = await http.get(
				uri,
				headers: headers,
			);

			debugPrint("========== RESPONSE debug ==========");
			debugPrint("STATUS CODE : ${response.statusCode}");
			debugPrint("BODY : ${response.body}");

			if (response.statusCode == 200) {
				final parsed = json.decode(response.body)
						.cast<Map<String, dynamic>>();

				debugPrint("TOTAL DATA : ${parsed.length}");

				return parsed
						.map<Sppa2parCariModel>(
							(json) => Sppa2parCariModel.fromJson(json),
				)
						.toList();
			} else {
				debugPrint("ERROR RESPONSE : ${response.body}");
				throw Exception(
					"Failed to load data. StatusCode: ${response.statusCode}",
				);
			}
		} catch (e, stackTrace) {
			debugPrint("========== ERROR ==========");
			debugPrint("ERROR : $e");
			debugPrint("STACK : $stackTrace");

			rethrow;
		}
	}
}
