import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/regklaim/sppaheader_model.dart';

class SppaHeaderAPI {

	Future<SppaHeaderModel> sppaHeaderLihatAPI(String sppa1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regklaim/sppaheader/getinfo";
		Map<String, String> queryParams = {'sppa1Id': sppa1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = SppaHeaderModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
