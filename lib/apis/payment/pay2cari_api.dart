import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/payment/pay2cari_model.dart';

class Pay2CariAPI{
	Future<List<Pay2CariModel>> getPay2CariAPI(String ar1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/payment/pay2cari/getlist";

		Map<String, String> queryParams = {"ar1Id": ar1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Pay2CariModel>((json) => Pay2CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
