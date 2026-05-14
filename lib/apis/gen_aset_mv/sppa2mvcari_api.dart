import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_aset_mv/sppa2mvcari_model.dart';

class Sppa2mvCariAPI{
	Future<List<Sppa2mvCariModel>> getSppa2mvCariAPI(String sppa1Id, String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/assetmv/sppa2mvcari/getlist";

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
				.map<Sppa2mvCariModel>((json) => Sppa2mvCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
