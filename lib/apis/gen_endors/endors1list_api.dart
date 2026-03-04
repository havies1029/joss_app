import 'dart:convert';
import 'package:flutter/foundation.dart'; // buat debugPrint
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_endors/endors1list_model.dart';

class Endors1ListAPI {
	Future<List<Endors1ListModel>> getEndors1ListAPI(String searchText, int hal) async {
		final String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/endors/endors1list/getlist";

		final Map<String, String> queryParams = {
			"searchText": searchText,
			"hal": hal.toString(),
		};

		final uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

		debugPrint("🌐 [Endors1ListAPI] Requesting data...");
		debugPrint("🔸 URL: $uri");
		debugPrint("🔸 Query Params: $queryParams");
		debugPrint("🔸 Token: ${AppData.userToken.substring(0, 10)}... (hidden)");

		try {
			final http.Response response = await http.get(
				uri,
				headers: {
					'Content-Type': 'application/json; odata=verbose',
					'Accept': 'application/json; odata=verbose',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
			);

			debugPrint("📩 [Endors1ListAPI] Response status: ${response.statusCode}");

			if (response.statusCode == 200) {
				// tampilkan ukuran body supaya gak berat di log
				debugPrint("✅ [Endors1ListAPI] Response body length: ${response.body.length} chars");

				final parsedJson = json.decode(response.body);
				if (parsedJson is List) {
					debugPrint("📦 [Endors1ListAPI] Parsed list length: ${parsedJson.length}");
				}

				final parsed = (parsedJson as List).cast<Map<String, dynamic>>();
				final result = parsed
						.map<Endors1ListModel>((json) => Endors1ListModel.fromJson(json))
						.toList();

				debugPrint("✅ [Endors1ListAPI] Mapped ${result.length} records into model");
				return result;
			} else {
				debugPrint("⚠️ [Endors1ListAPI] Request failed: ${response.statusCode}");
				debugPrint("⚠️ [Endors1ListAPI] Response body: ${response.body}");
				throw Exception("Failed to load data - HTTP ${response.statusCode}");
			}
		} catch (e, stack) {
			debugPrint("💥 [Endors1ListAPI] Exception: $e");
			debugPrint(stack.toString());
			rethrow; // biar error tetap dilempar ke layer atas
		}
	}
}
