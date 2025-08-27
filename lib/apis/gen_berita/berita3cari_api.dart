import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_berita/berita3cari_model.dart';

class Berita3CariAPI{
	Future<List<Berita3CariModel>> getBerita3CariAPI(String berita1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/berita/berita3cari/getlist";

    Map<String, String> queryParams = {"berita1Id": berita1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Berita3CariModel>((json) => Berita3CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data paragraph");
		}
	}
}
