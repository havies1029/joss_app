import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/calpar/calpar2form_model.dart';

class Calpar2FormAPI {

	Future<ReturnDataAPI> calpar2FormTambahAPI(Calpar2FormModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/calpar/calpar2form/create";
		Map<String, String> queryParams = {"modul_id": "calpar2FormTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}
	Future<bool> calpar2FormUbahAPI(Calpar2FormModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/calpar/calpar2form/update";
		Map<String, String> queryParams = {"modul_id": "calpar2FormUbahAPI"};

		var uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

		final http.Response response = await http.post(uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()));

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<bool> calpar2FormHapusAPI(String calpar2Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calpar/calpar2form/delete";
		Map<String, String> queryParams = {
			'calpar2Id': calpar2Id,
			'modul_id': 'calpar2FormHapusAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<Calpar2FormModel> calpar2FormLihatAPI(String calpar1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/calpar/calpar2form/read";
		Map<String, String> queryParams = {'calpar1Id': calpar1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Calpar2FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
