import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';

class Calmv1CrudAPI {

	Future<ReturnDataAPI> calmv1CrudTambahAPI(Calmv1CrudModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/calmv/calmv1crud/create";
		Map<String, String> queryParams = {"modul_id": "calmv1CrudTambahAPI"};
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
	Future<bool> calmv1CrudUbahAPI(Calmv1CrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/calmv/calmv1crud/update";
		Map<String, String> queryParams = {"modul_id": "calmv1CrudUbahAPI"};

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
	Future<bool> calmv1CrudHapusAPI(String calmv1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calmv/calmv1crud/delete";
		Map<String, String> queryParams = {
			'calmv1Id': calmv1Id,
			'modul_id': 'calmv1CrudHapusAPI'};
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
	Future<Calmv1CrudModel> calmv1CrudLihatAPI(String calmv1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/calmv/calmv1crud/read";
		Map<String, String> queryParams = {'calmv1Id': calmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Calmv1CrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}


	Future<ReturnDataAPI> calmMvToRegMvAPI(String calmv1Id) async {

		String endpoint = "${AppData.prefixEndPoint}/api/calmv/calmv1crud/calmvtoregmv";

		Map<String, String> queryParams = {
			'calmv1Id': calmv1Id,
			'modul_id': 'calmMvToRegMvAPI',
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		ReturnDataAPI returnData;

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}

		return returnData; // ⬅️ bedanya hanya ini!
	}
}
