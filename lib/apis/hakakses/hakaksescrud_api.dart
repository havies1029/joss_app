import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/hakakses/hakaksescrud_model.dart';

class HakaksesCrudAPI {

	Future<HakaksesCrudModel> hakaksesCrudLihatAPI() async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/userprofile/hakakses";

		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint);

		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = HakaksesCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
