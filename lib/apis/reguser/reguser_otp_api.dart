import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/reguser/reguser_otp_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ReguserOtpApi {
  Future<ReturnDataAPI> kirim(ReguserOtpSendModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/send";
    final queryParams = {"modul_id": "regUserOtpKirimAPI"};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    try {
      final response = await http.post(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
        },
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(
        success: false,
        data: "Gagal mengirim OTP.",
        rowcount: 0,
      );
    } catch (_) {
      return ReturnDataAPI(
        success: false,
        data: "Gagal mengirim OTP.",
        rowcount: 0,
      );
    }
  }

  Future<ReturnDataAPI> validasi(ReguserOtpValidateModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/validate";
    final queryParams = {"modul_id": "regUserOtpValidasiAPI"};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    try {
      final response = await http.post(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
        },
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(
        success: false,
        data: "Gagal memvalidasi OTP.",
        rowcount: 0,
      );
    } catch (_) {
      return ReturnDataAPI(
        success: false,
        data: "Gagal memvalidasi OTP.",
        rowcount: 0,
      );
    }
  }
}
