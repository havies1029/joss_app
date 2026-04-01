import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_profile/mrekan1crud_model.dart';

class MRekan1CrudAPI {

	Future<MRekan1CrudModel> mRekan1CrudLihatAPI() async {
		String lihatEndpoint =
				"${AppData.prefixEndPoint}/api/profile/rekan1crud/read";
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint);

		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final decoded = jsonDecode(response.body);

			var returnData = MRekan1CrudModel.fromJson(decoded);

			return returnData;
		} else {
			throw Exception("Failed to load data");
		}
	}

  Future<bool> mRekan1SetujuTCAPI(String mrekanId) async {
		String setujuTCEndpoint =
			"${AppData.prefixEndPoint}/api/profile/rekan1crud/setujutc";
		Map<String, String> queryParams = {"rekanId": mrekanId, "modul_id": "mRekan1SetujuTCAPI"};

		var uri = AppData.uriHtpp(AppData.httpAuthority, setujuTCEndpoint, queryParams);

		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			return returnData.success;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
