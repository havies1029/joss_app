import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/reguser/reguser_otp_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ReguserOtpApi {
  Future<ReturnDataAPI> kirim(ReguserOtpSendModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/send";
    final queryParams = {"modul_id": "regUserOtpKirimAPI"};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);
    final body = jsonEncode(record.toJson());

    debugPrint('[REGUSER_OTP_KIRIM] URI: $uri');
    debugPrint('[REGUSER_OTP_KIRIM] PAYLOAD: $body');

    try {
      final response = await http.post(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
        },
        body: body,
      );

      debugPrint('[REGUSER_OTP_KIRIM] STATUS: ${response.statusCode}');
      debugPrint('[REGUSER_OTP_KIRIM] BODY: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
        } catch (e, st) {
          debugPrint('[REGUSER_OTP_KIRIM] JSON PARSE ERROR: $e');
          debugPrint('[REGUSER_OTP_KIRIM] JSON PARSE STACK: $st');

          return ReturnDataAPI(
            success: false,
            data: 'Response OTP tidak valid: ${response.body}',
            rowcount: 0,
          );
        }
      }

      return ReturnDataAPI(
        success: false,
        data:
        'HTTP ${response.statusCode}: ${response.body.isNotEmpty ? response.body : response.reasonPhrase ?? 'Tidak ada response body'}',
        rowcount: 0,
      );
    } catch (e, st) {
      debugPrint('[REGUSER_OTP_KIRIM] EXCEPTION: $e');

      return ReturnDataAPI(
        success: false,
        data: 'Exception saat kirim OTP: $e',
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

  Future<ReturnDataAPI> hpStatus(ReguserOtpHpRequestModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/hp-status";
    final queryParams = {"modul_id": "regUserOtpHpStatusAPI"};
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
        data: "Gagal mengecek status No. HP.",
        rowcount: 0,
      );
    } catch (_) {
      return ReturnDataAPI(
        success: false,
        data: "Gagal mengecek status No. HP.",
        rowcount: 0,
      );
    }
  }

  Future<ReturnDataAPI> kirimPassword(ReguserOtpHpRequestModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/send-password";
    final queryParams = {"modul_id": "regUserOtpPasswordKirimAPI"};
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
        data: "Gagal mengirim kata sandi.",
        rowcount: 0,
      );
    } catch (_) {
      return ReturnDataAPI(
        success: false,
        data: "Gagal mengirim kata sandi.",
        rowcount: 0,
      );
    }
  }
}
