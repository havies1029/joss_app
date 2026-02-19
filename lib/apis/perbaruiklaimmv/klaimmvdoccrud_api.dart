//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvdoccrud_model.dart';

class KlaimmvdoccrudAPI {

	Future<ReturnDataAPI> klaimmvdoccrudTambahAPI(KlaimmvdoccrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvdoccrud/create";
		Map<String, String> queryParams = {"modul_id": "klaimmvdoccrudTambahAPI"};
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
	Future<bool> klaimmvdoccrudUbahAPI(KlaimmvdoccrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvdoccrud/update";
		Map<String, String> queryParams = {"modul_id": "klaimmvdoccrudUbahAPI"};

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
	Future<bool> klaimmvdoccrudHapusAPI(String klaim1Id, String mjenisdocId, String jenisDocLain) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvdoccrud/delete";
		Map<String, String> queryParams = {
			'klaim1Id': klaim1Id,
			'mjenisdocId': mjenisdocId,
			'jenisDocLain': jenisDocLain,
			'modul_id': 'klaimmvdoccrudHapusAPI'};
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
	Future<KlaimmvdoccrudModel?> klaimmvdoccrudLihatAPI(String klaim5Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaimmvdoccrud/read";
		Map<String, String> queryParams = {'klaim5Id': klaim5Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		try{
			final http.Response response =
				await http.get(uri, headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			});

			if (response.statusCode == 200) {
				var returnData = KlaimmvdoccrudModel.fromJson(jsonDecode(response.body));
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
