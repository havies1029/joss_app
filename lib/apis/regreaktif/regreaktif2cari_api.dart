import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regreaktif/regreaktif2cari_model.dart';

class Regreaktif2CariAPI{
	Future<List<Regreaktif2CariModel>> getRegreaktif2CariAPI(String regreaktif1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/regreaktif/regreaktif2cari/getlist";

		Map<String, String> queryParams = {"regreaktif1Id": regreaktif1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Regreaktif2CariModel>((json) => Regreaktif2CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
