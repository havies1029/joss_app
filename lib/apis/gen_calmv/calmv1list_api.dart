import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_calmv/calmv1list_model.dart';

import '../../models/responseAPI/returndataapi_model.dart';


class Calmv1ListAPI{
	Future<List<Calmv1ListModel>> getCalmv1ListAPI(String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/calmv/calmv1list/getlist";

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
					.map<Calmv1ListModel>((json) => Calmv1ListModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<ReturnDataAPI> calmv2RegmvAPI(String calmv1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calmv/calmv2regmv";
		Map<String, String> queryParams = {
			'calmv1Id': calmv1Id,
			'modul_id': 'calmv2RegmvAPI'};
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
