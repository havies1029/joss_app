import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiocari_model.dart';
import 'package:http/http.dart' as http;


class KlaimrasiocobCariAPI{
	Future<KlaimrasiocariModel> getKlaimrasiocobCariAPI(String searchText) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaimrasio/klaimrasiocobcari/getlist";

		Map<String, String> queryParams = {"searchText": searchText};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final Map<String, dynamic> jsonData =
          json.decode(response.body) as Map<String, dynamic>;

      return KlaimrasiocariModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}
}
