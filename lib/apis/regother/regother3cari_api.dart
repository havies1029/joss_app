import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regother/regother3cari_model.dart';

class Regother3cariAPI{
	Future<List<Regother3cariModel>> getRegother3cariAPI(String regother1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regother/regother3cari/getlist";

		Map<String, String> queryParams = {"regother1Id": regother1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Regother3cariModel>((json) => Regother3cariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
