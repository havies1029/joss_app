import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_aset_health/sppa2healthcari_model.dart';

class Sppa2healthCariAPI{
	Future<List<Sppa2healthCariModel>> getSppa2healthCariAPI(String sppa1Id, String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/assethealth/sppa2healthcari/getlist";

		Map<String, String> queryParams = {"sppa1Id": sppa1Id, "searchText": searchText, "hal": hal.toString()};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Sppa2healthCariModel>((json) => Sppa2healthCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
