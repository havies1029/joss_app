import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_endors/endors1list_model.dart';

class Endors1ListAPI{
	Future<List<Endors1ListModel>> getEndors1ListAPI(String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/endors/endors1list/getlist";

		Map<String, String> queryParams = {"searchText": searchText, "hal": hal.toString()};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<Endors1ListModel>((json) => Endors1ListModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
