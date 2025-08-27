import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/simulmv/simulmvcrud_model.dart';

class SimulmvCrudAPI {

	Future<ReturnDataAPI> simulmvCrudTambahAPI(SimulmvCrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/create";
		Map<String, String> queryParams = {"modul_id": "simulmvCrudTambahAPI"};
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
	Future<bool> simulmvCrudUbahAPI(SimulmvCrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/update";
		Map<String, String> queryParams = {"modul_id": "simulmvCrudUbahAPI"};

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
	Future<bool> simulmvCrudHapusAPI(String simulmv1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/delete";
		Map<String, String> queryParams = {
			'simulmv1Id': simulmv1Id,
			'modul_id': 'simulmvCrudHapusAPI'};
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
	Future<SimulmvCrudModel> simulmvCrudLihatAPI(String simulmv1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/read";
		Map<String, String> queryParams = {'simulmv1Id': simulmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = SimulmvCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<SimulmvCrudModel> simulMVCrudInitValueAPI() async {
		String initValueEndpoint = "${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/initvalue";		
		var uri = AppData.uriHtpp(AppData.httpAuthority, initValueEndpoint);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = SimulmvCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
