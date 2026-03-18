import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RekanPicCobCariAPI {

	Future<List<RekanPicCobCariModel>> getRekanPicCobCariAPI(
			String rekanPicId, String searchText, int hal) async {

		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/profile/piccobcari/getlist";

		Map<String, String> queryParams = {
			"rekanPICId": rekanPicId.trim(),
			"searchText": searchText,
			"hal": hal.toString()
		};

		var uri = AppData.uriHtpp(
				AppData.httpAuthority, urlGetListEndPoint, queryParams);

		/// ================= REQUEST =================
		debugPrint("===== REQUEST GET PIC COB =====");
		debugPrint("URL : $uri");
		debugPrint("PARAMS : $queryParams");

		try {

			final http.Response response = await http.get(
				uri,
				headers: {
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
			);

			/// ================= RESPONSE =================
			debugPrint("===== RESPONSE GET PIC COB =====");
			debugPrint("STATUS : ${response.statusCode}");
			debugPrint("BODY : ${response.body}");

			if (response.statusCode == 200) {
				final parsed =
				json.decode(response.body).cast<Map<String, dynamic>>();

				return parsed
						.map<RekanPicCobCariModel>(
								(json) => RekanPicCobCariModel.fromJson(json))
						.toList();
			} else {
				throw Exception("Failed to load data");
			}

		} catch (e) {

			/// ================= ERROR =================
			debugPrint("===== ERROR GET PIC COB =====");
			debugPrint(e.toString());

			rethrow;
		}
	}



	Future<ReturnDataAPI> rekanPicCobUpdateListAPI(
			String rekanPicId,
			List<RekanPicCobCariCheckboxModel> listChecked) async {

		String updateListEndpoint =
				"${AppData.prefixEndPoint}/api/profile/piccobcari/updatelistchecked";

		Map<String, String> queryParams = {
			"rekanPicId": rekanPicId,
			"modul_id": "RekanPicCobUpdateListAPI"
		};

		var uri = AppData.uriHtpp(
				AppData.httpAuthority, updateListEndpoint, queryParams);

		final fixedList = listChecked.map((e) {
			return {
				"mcobId": e.mcobId,
				"mrekanpicId": rekanPicId,
				"isChecked": e.isChecked,
			};
		}).toList();

		/// ================= REQUEST =================
		debugPrint("===== REQUEST UPDATE COB =====");
		debugPrint("URL : $uri");
		debugPrint("BODY : ${jsonEncode(fixedList)}");

		try {

			final response = await http.post(
				uri,
				headers: {
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: jsonEncode(fixedList),
			);

			/// ================= RESPONSE =================
			debugPrint("===== RESPONSE UPDATE COB =====");
			debugPrint("STATUS : ${response.statusCode}");
			debugPrint("BODY : ${response.body}");

			ReturnDataAPI returnData;

			if (response.statusCode == 200) {
				returnData =
						ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
			}

			return returnData;

		} catch (e) {

			/// ================= ERROR =================
			debugPrint("===== ERROR UPDATE COB =====");
			debugPrint(e.toString());

			rethrow;
		}
	}
}
