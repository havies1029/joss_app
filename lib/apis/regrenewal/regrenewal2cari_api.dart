import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regrenewal/regrenewal2cari_model.dart';

class Regrenewal2CariAPI{
	Future<List<Regrenewal2CariModel>> getRegrenewal2CariAPI(String regrenew1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regrenewal/regrenewal2cari/getlist";

		Map<String, String> queryParams = {"regrenew1Id": regrenew1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Regrenewal2CariModel>((json) => Regrenewal2CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
