import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/asetothers/sppa2otherscari_model.dart';

class Sppa2othersCariAPI{
		Future<List<Sppa2othersCariModel>> getSppa2othersCariAPI(String sppa1Id, String searchText, int hal) async {
			String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/asetothers/sppa2otherscari/getlist";

			Map<String, String> queryParams = {"sppa1Id": sppa1Id, "searchText": searchText, "hal": hal.toString()};
			var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
			final http.Response response = await http.get(uri, headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			});

			if (response.statusCode == 200) {
				final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
				return parsed
					.map<Sppa2othersCariModel>((json) => Sppa2othersCariModel.fromJson(json))
					.toList();
			} else {
				throw Exception("Failed to load data");
			}
		}
}
