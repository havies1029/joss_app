import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_cob_app/cobcari_model.dart';

class CobCariAPI{
	Future<List<CobCariModel>> getCobCariAPI() async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/cobapp/cobcari/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<CobCariModel>((json) => CobCariModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<List<CobCariModel>> getCobManPolCariAPI() async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/cobapp/cobmanpolcari/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<CobCariModel>((json) => CobCariModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}


}
