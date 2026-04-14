import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/klaimringkas/klaimringkascari_model.dart';

class KlaimringkasCariAPI{
	Future<List<KlaimringkasCariModel>> getKlaimringkasCariAPI(String statusId) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaimringkas/klaimringkascari/getlist";

    Map<String, String> queryParams = {"statusId": statusId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

	if (response.statusCode == 200) {      
      final decoded = json.decode(response.body);
      if (decoded == null) return [];
      return (decoded as List)
          .cast<Map<String, dynamic>>()
          .map<KlaimringkasCariModel>((json) => KlaimringkasCariModel.fromJson(json))
          .toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
