import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscari_model.dart';

class KlaimmvstatuscariAPI{
	Future<List<KlaimmvstatuscariModel>> getKlaimmvstatuscariAPI(String klaim1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvstatuscari/getlist";
    
    Map<String, String> queryParams = {"klaim1Id": klaim1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<KlaimmvstatuscariModel>((json) => KlaimmvstatuscariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
