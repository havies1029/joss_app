import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';

class MRekanBankCrudAPI {

	Future<ReturnDataAPI> mRekanBankCrudTambahAPI(MRekanBankCrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/profile/mrekanbankcrud/create";
		Map<String, String> queryParams = {"modul_id": "mRekanBankCrudTambahAPI"};
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

	Future<bool> mRekanBankCrudUbahAPI(MRekanBankCrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/profile/mrekanbankcrud/update";
		Map<String, String> queryParams = {"modul_id": "mRekanBankCrudUbahAPI"};

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
	Future<bool> mRekanBankCrudHapusAPI(String mrekanbankId) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/profile/mrekanbankcrud/delete";
		Map<String, String> queryParams = {
			'mrekanbankId': mrekanbankId,
			'modul_id': 'mRekanBankCrudHapusAPI'};
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

	Future<MRekanBankCrudModel> mRekanBankCrudLihatAPI() async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/profile/mrekanbankcrud/read";

		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, {});

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		if (response.statusCode == 200) {
			return MRekanBankCrudModel.fromJson(jsonDecode(response.body));
		} else {
			throw Exception("Failed to load data");
		}
	}
}
