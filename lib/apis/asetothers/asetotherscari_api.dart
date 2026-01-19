import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/asetothers/asetotherscari_model.dart';

class AsetothersCariAPI{
	Future<List<AsetothersCariModel>> getAsetothersCariAPI(String cobId, String statusId, String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/assetothers/asetotherscari/getlist";

		Map<String, String> queryParams = {"cobId": cobId, "statusId": statusId, "searchText": searchText, "hal": hal.toString()};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<AsetothersCariModel>((json) => AsetothersCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
