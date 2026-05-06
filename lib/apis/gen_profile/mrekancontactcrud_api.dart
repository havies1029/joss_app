import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';

class MRekanContactCrudAPI {
	Future<bool> mRekanContactCrudUbahAPI(MRekanContactCrudModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/profile/mrekancontactcrud/update";

		Map<String, String> queryParams = {
			"modul_id": "mRekanContactCrudUbahAPI"
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			ubahEndpoint,
			queryParams,
		);

		final bodyJson = jsonEncode(record.toJson());

		debugPrint("=== API REQUEST ===");
		debugPrint("URL     : $uri");
		debugPrint("BODY    : $bodyJson");
		debugPrint("TOKEN   : ${AppData.userToken}");
		debugPrint("===================");

		try {
			final http.Response response = await http.post(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json',
					'Accept': 'application/json',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: bodyJson,
			);

			debugPrint("=== API RESPONSE ===");
			debugPrint("STATUS  : ${response.statusCode}");
			debugPrint("BODY    : ${response.body}");
			debugPrint("====================");

			if (response.statusCode == 200) {
				final returnData =
				ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));

				debugPrint("PARSED SUCCESS : ${returnData.success}");
				debugPrint("PARSED DATA    : ${returnData.data}");

				return returnData.success;
			} else {
				debugPrint("ERROR: Non-200 response");

				return false;
			}
		} catch (e, stack) {
			debugPrint("=== API ERROR ===");
			debugPrint("ERROR : $e");
			debugPrint("STACK : $stack");
			debugPrint("=================");

			return false;
		}
	}
	
	Future<MRekanContactCrudModel> mRekanContactCrudLihatAPI() async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/profile/mrekancontactcrud/read";
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = MRekanContactCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
