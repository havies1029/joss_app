import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_regmv/regmv7cari_model.dart';

class Regmv7CariAPI{
	Future<List<Regmv7CariModel>> getRegmv7CariAPI(String regmv1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regmv/regmv7cari/getlist";

		Map<String, String> queryParams = {"regmv1Id": regmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Regmv7CariModel>((json) => Regmv7CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
