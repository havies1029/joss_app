import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/login/emailverification_model.dart';

class EmailVerificationAPI {

	Future<ReturnDataAPI> emailVerificationTambahAPI(EmailVerificationModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/login/emailverification/create";
		Map<String, String> queryParams = {"modul_id": "emailVerificationTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

    //debugPrint("emailVerificationTambahAPI #10");
    //debugPrint("URI: $uri");
    //debugPrint("Request Body: ${jsonEncode(record.toJson())}");

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
			},
			body: jsonEncode(record.toJson()));

      

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}

  Future<ReturnDataAPI> validasiPinEmailAPI(EmailVerificationModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/login/emailverification/validasipinemail";
		Map<String, String> queryParams = {"modul_id": "validasiPinEmailAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
			},
			body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}
	
}
