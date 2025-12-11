import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regpar/regpar6cari_model.dart';

class Regpar6CariAPI{
	Future<List<Regpar6CariModel>> getRegpar6CariAPI(String regpar1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regpar/regpar6cari/getlist";
    Map<String, String> queryParams = {"regpar1Id": regpar1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Regpar6CariModel>((json) => Regpar6CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
