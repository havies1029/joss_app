import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/calpar/calpar1list_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class Calpar1ListAPI{
	Future<List<Calpar1ListModel>> getCalpar1ListAPI(String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/calpar/calpar1list/getlist";

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
				.map<Calpar1ListModel>((json) => Calpar1ListModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<ReturnDataAPI> calpar2RegparAPI(String calpar1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calpar/calpar2regpar";
		Map<String, String> queryParams = {
			'calpar1Id': calpar1Id,
			'modul_id': 'calpar2RegparAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbose',
			'Accept': 'application/json; odata=verbose',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}
}