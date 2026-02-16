import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';
class Klaim5cariAPI {
	Future<List<Klaim5cariModel>> getKlaim5cariAPI(String klaim1Id) async {
		try {
			String urlGetListEndPoint =
					"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaim5cari/getlist";

			Map<String, String> queryParams = {'klaim1Id': klaim1Id};
			var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
			);

			// 1) cek status code
			if (response.statusCode != 200) {
				throw Exception(
					"HTTP ${response.statusCode} ${response.reasonPhrase} | body: ${_short(response.body)}",
				);
			}

			// 2) decode JSON
			final decoded = json.decode(response.body);

			// 3) pastikan bentuknya List
			if (decoded is! List) {
				throw Exception(
					"Response JSON bukan List. Tipe: ${decoded.runtimeType} | body: ${_short(response.body)}",
				);
			}

			// 4) mapping ke model (aman)
			return decoded
					.whereType<Map<String, dynamic>>()
					.map<Klaim5cariModel>((e) => Klaim5cariModel.fromJson(e))
					.toList();
		} on FormatException catch (e) {
			// error parsing JSON
			throw Exception("Parse JSON gagal: ${e.message}");
		} on http.ClientException catch (e) {
			// error network dari package http
			throw Exception("HTTP Client error: $e");
		} catch (e) {
			// error lain (mapping null, dll)
			throw Exception("Failed to load data: $e");
		}
	}

	String _short(String s, {int max = 250}) {
		if (s.length <= max) return s;
		return '${s.substring(0, max)}...';
	}
}