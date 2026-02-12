import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/klaimrinci/groupcobcari_model.dart';

class GroupcobCariAPI{
	Future<List<GroupcobCariModel>> getGroupcobCariAPI(String statusId, String searchText) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaimrinci/groupcobcari/getlist";

    Map<String, String> queryParams = {"statusId": statusId, "searchText": searchText};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<GroupcobCariModel>((json) => GroupcobCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
