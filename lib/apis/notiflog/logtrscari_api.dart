import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/notiflog/logtrscari_model.dart';

class LogtrscariAPI{
	Future<List<LogtrscariModel>> getLogtrscariAPI(String groupLogId, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/notiflog/logtrscari/getlist";

    var queryParameters = {
      'groupLogId': groupLogId,
      'hal': hal.toString(),
    };
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParameters);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<LogtrscariModel>((json) => LogtrscariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}

  Future<List<LogtrscariModel>> getLogtrscaritopxAPI() async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/notiflog/logtrscari/getlisttopx";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<LogtrscariModel>((json) => LogtrscariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
