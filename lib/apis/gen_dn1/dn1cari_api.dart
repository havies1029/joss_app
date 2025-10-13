import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_dn1/dn1cari_model.dart';

class Dn1CariAPI {
	Future<List<Dn1CariModel>> getDn1CariAPI(String sppa1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/dn/dn1cari/getlist";

		Map<String, String> queryParams = {"sppa1Id": sppa1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

		print("🌐 [Dn1CariAPI] Request URL: $uri");
		print("🔑 [Dn1CariAPI] Token: ${AppData.userToken.substring(0, 10)}..."); // potong biar aman

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbose',
				'Accept': 'application/json; odata=verbose',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		print("📡 [Dn1CariAPI] Status Code: ${response.statusCode}");
		print("📦 [Dn1CariAPI] Raw Body: ${response.body}");

		if (response.statusCode == 200) {
			try {
				final decoded = json.decode(response.body);

				// cek struktur data
				if (decoded is List) {
					print("✅ [Dn1CariAPI] Response is a List with ${decoded.length} items");
					return decoded
							.map<Dn1CariModel>((json) => Dn1CariModel.fromJson(json))
							.toList();
				} else if (decoded is Map && decoded.containsKey('data')) {
					final listData = decoded['data'] as List;
					print("✅ [Dn1CariAPI] Response has 'data' key with ${listData.length} items");
					return listData
							.map<Dn1CariModel>((json) => Dn1CariModel.fromJson(json))
							.toList();
				} else {
					print("⚠️ [Dn1CariAPI] Unknown response format: ${decoded.runtimeType}");
					return [];
				}
			} catch (e, stack) {
				print("💥 [Dn1CariAPI] JSON decode error: $e");
				print(stack);
				return [];
			}
		} else {
			print("🚫 [Dn1CariAPI] Failed to fetch data — status: ${response.statusCode}");
			throw Exception("Failed to load data");
		}
	}
}
