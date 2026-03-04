import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';

class MRekanGeneralIdvCrudAPI {

	Future<bool> mRekanGeneralIdvCrudUbahAPI(MRekanGeneralIdvCrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/profile/rekangeneralidvcrud/update";
		Map<String, String> queryParams = {"modul_id": "mRekanGeneralIdvCrudUbahAPI"};

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
	
	Future<MRekanGeneralIdvCrudModel> mRekanGeneralIdvCrudLihatAPI() async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/profile/rekangeneralidvcrud/read";
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = MRekanGeneralIdvCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data general individu");
		}
	}
}
