//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/klaimlacak/klaimnilaicrud_model.dart';

class KlaimnilaicrudAPI {

	Future<ReturnDataAPI> klaimnilaicrudTambahAPI(KlaimnilaicrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/klaimlacak/klaimnilaicrud/create";
		Map<String, String> queryParams = {"modul_id": "klaimnilaicrudTambahAPI"};
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
	Future<bool> klaimnilaicrudUbahAPI(KlaimnilaicrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/klaimlacak/klaimnilaicrud/update";
		Map<String, String> queryParams = {"modul_id": "klaimnilaicrudUbahAPI"};

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
	Future<bool> klaimnilaicrudHapusAPI(String klaimnilaiId) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/klaimlacak/klaimnilaicrud/delete";
		Map<String, String> queryParams = {
			'klaimnilaiId': klaimnilaiId,
			'modul_id': 'klaimnilaicrudHapusAPI'};
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
	Future<KlaimnilaicrudModel?> klaimnilaicrudLihatAPI(String klaimnilaiId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/klaimlacak/klaimnilaicrud/read";
		Map<String, String> queryParams = {'klaimnilaiId': klaimnilaiId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		try{
			final http.Response response =
				await http.get(uri, headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			});

			if (response.statusCode == 200) {
				var returnData = KlaimnilaicrudModel.fromJson(jsonDecode(response.body));
				return returnData;
			}
			if (response.statusCode == 404) {
				return null;
			}
			throw HttpException('HTTP ${response.statusCode}: ${response.body}');
		} catch (e) {
			throw Exception("Failed to load data: $e");
		}
	}
}
