//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/klaimbatal/klaimbatalcrud_model.dart';

class KlaimbatalcrudAPI {

	Future<bool> klaimbatalcrudUbahAPI(KlaimbatalcrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/klaimbatal/klaimbatalcrud/update";
		Map<String, String> queryParams = {"modul_id": "klaimbatalcrudUbahAPI"};

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
  
}
