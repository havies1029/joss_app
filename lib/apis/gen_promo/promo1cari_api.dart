import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_promo/promo1cari_model.dart';

class Promo1CariAPI{
	Future<List<Promo1CariModel>> getPromo1CariAPI(int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/promo/promo1cari/getlist";

		Map<String, String> queryParams = {"hal": hal.toString()};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Promo1CariModel>((json) => Promo1CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
