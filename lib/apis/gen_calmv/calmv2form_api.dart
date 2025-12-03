import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';

class Calmv2FormAPI {

	Future<ReturnDataAPI> calmv2FormTambahAPI(Calmv2FormModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/calmv/calmv2form/create";
		Map<String, String> queryParams = {"modul_id": "calmv2FormTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		ReturnDataAPI returnData;

		try {
			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()),
			);

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
			}
		} catch (e, stacktrace) {
			returnData = ReturnDataAPI(success: false, data: e.toString(), rowcount: 0);
		}
		return returnData;
	}

	Future<bool> calmv2FormUbahAPI(Calmv2FormModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/calmv/calmv2form/update";
		Map<String, String> queryParams = {"modul_id": "calmv2FormUbahAPI"};

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
	Future<bool> calmv2FormHapusAPI(String calmv2Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/calmv/calmv2form/delete";
		Map<String, String> queryParams = {
			'calmv2Id': calmv2Id,
			'modul_id': 'calmv2FormHapusAPI'};
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
	Future<Calmv2FormModel> calmv2FormLihatAPI(String calmv2Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/calmv/calmv2form/read";
		Map<String, String> queryParams = {'calmv2Id': calmv2Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Calmv2FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
