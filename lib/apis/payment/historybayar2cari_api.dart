import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/payment/historybayar2cari_model.dart';

class Historybayar2CariAPI{
	Future<List<Historybayar2CariModel>> getHistorybayar2CariAPI(String inv1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/payment/historybayar2cari/getlist";

		Map<String, String> queryParams = {"inv1Id": inv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Historybayar2CariModel>((json) => Historybayar2CariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
