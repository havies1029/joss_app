import 'dart:convert';

import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/authentication/reset_password_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ForgotPasswordApi {

  Future<ReturnDataAPI> requestOtpAPI(RequestOtpModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/requestotp/create";
		Map<String, String> queryParams = {"modul_id": "forgotPasswordRequestOtpAPI"};
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

  Future<ReturnDataAPI> validasiOtpAPI(RequestOtpModel record) async {
		String endpoint =
			"${AppData.prefixEndPoint}/api/requestotp/validasiotp";
		Map<String, String> queryParams = {"modul_id": "validasiOtpAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

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

  Future<ReturnDataAPI> resendOtpAPI(RequestOtpModel record) async {
		String endpoint =
			"${AppData.prefixEndPoint}/api/requestotp/resendotp";
		Map<String, String> queryParams = {"modul_id": "resendOtpAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbose',
				'Accept': 'application/json; odata=verbose',
			},
			body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}

  Future<bool> resetPasswordApi(ResetPasswordModel pswd) async {
    String resetPswdEndpoint =
        "${AppData.prefixEndPoint}/api/login/resetpassword";
    Map<String, String> queryParams = {"modul_id": "resetPasswordApi"};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, resetPswdEndpoint, queryParams);
    final http.Response response = await http.post(uri,
        headers: AppData.httpHeaders, body: jsonEncode(pswd.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
