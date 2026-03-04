import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/klaim/klaim2list_model.dart';

class Klaim2ListAPI{
	Future<List<Klaim2ListModel>> getKlaim2ListAPI(String klaim1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaim/klaim2list/getlist";

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
				.map<Klaim2ListModel>((json) => Klaim2ListModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
