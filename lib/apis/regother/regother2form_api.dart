import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regother/regother2form_model.dart';

class Regother2FormAPI {

	Future<ReturnDataAPI> regother2FormTambahAPI(Regother2FormModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/regother/regother2form/create";
		Map<String, String> queryParams = {"modul_id": "regother2FormTambahAPI"};
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
	Future<bool> regother2FormUbahAPI(Regother2FormModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/regother/regother2form/update";
		Map<String, String> queryParams = {"modul_id": "regother2FormUbahAPI"};

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
	Future<bool> regother2FormHapusAPI(String regother2Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/regother/regother2form/delete";
		Map<String, String> queryParams = {
			'regother2Id': regother2Id,
			'modul_id': 'regother2FormHapusAPI'};
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
	Future<Regother2FormModel> regother2FormLihatAPI(String regother2Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regother/regother2form/read";
		Map<String, String> queryParams = {'regother2Id': regother2Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Regother2FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
