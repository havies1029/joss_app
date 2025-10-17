import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RekanPicCobCariAPI{
	Future<List<RekanPicCobCariModel>> getRekanPicCobCariAPI(
			String rekanPicId, String searchText, int hal) async {

		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/profile/piccobcari/getlist";

		Map<String, String> queryParams = {
			"rekanPICId": rekanPicId.trim(), // pastikan clean
			"searchText": searchText,
			"hal": hal.toString()
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);

		final http.Response response = await http.get(uri, headers: {
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed.map<RekanPicCobCariModel>(
							(json) => RekanPicCobCariModel.fromJson(json)).toList();
		} else {
			throw Exception("Failed to load data");
		}
	}


	Future<ReturnDataAPI> rekanPicCobUpdateListAPI(
			String rekanPicId, List<RekanPicCobCariCheckboxModel> listChecked) async {

		String updateListEndpoint =
				"${AppData.prefixEndPoint}/api/profile/piccobcari/updatelistchecked";
		Map<String, String> queryParams = {
			"rekanPicId": rekanPicId,
			"modul_id": "RekanPicCobUpdateListAPI"
		};
		var uri = AppData.uriHtpp(AppData.httpAuthority, updateListEndpoint, queryParams);

		final fixedList = listChecked.map((e) {
			return {
				"mcobId": e.mcobId,
				"mrekanpicId": rekanPicId,
				"isChecked": e.isChecked,
			};
		}).toList();

		final response = await http.post(
			uri,
			headers: {
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
			body: jsonEncode(fixedList),
		);

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}

}
