import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/reguser/reguser_otp_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ReguserOtpApi {
  ReturnDataAPI _networkFailure(String action, Object error) {
    debugPrint('[$action] EXCEPTION: $error');
    return ReturnDataAPI(
      success: false,
      data: 'Tidak dapat terhubung ke server.',
      rowcount: 0,
    );
  }

  Future<ReturnDataAPI> kirim(ReguserOtpSendModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/send";
    final queryParams = {"modul_id": "regUserOtpKirimAPI"};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);
    final body = jsonEncode(record.toJson());

    debugPrint('[REGUSER_OTP_KIRIM] URI: $uri');
    debugPrint('[REGUSER_OTP_KIRIM] PAYLOAD: $body');

    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json; odata=verbose',
              'Accept': 'application/json; odata=verbose',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

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
    } on SocketException catch (e) {
      return _networkFailure('REGUSER_OTP_KIRIM', e);
    } on TimeoutException catch (e) {
      return _networkFailure('REGUSER_OTP_KIRIM', e);
    } on http.ClientException catch (e) {
      return _networkFailure('REGUSER_OTP_KIRIM', e);
    } catch (e) {
      debugPrint('[REGUSER_OTP_KIRIM] EXCEPTION: $e');
      return ReturnDataAPI(
        success: false,
        data: 'Gagal mengirim OTP.',
        rowcount: 0,
      );
    }
  }

  Future<ReturnDataAPI> validasi(ReguserOtpValidateModel record) async {
    final endpoint = "${AppData.prefixEndPoint}/api/reguser/otp/validate";
    final queryParams = {"modul_id": "regUserOtpValidasiAPI"};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);
    final body = jsonEncode(record.toJson());

    debugPrint('[REGUSER_OTP_VALIDASI] URI: $uri');
    debugPrint('[REGUSER_OTP_VALIDASI] PAYLOAD: ${jsonEncode({
          "requestId": record.requestId,
          "target": record.target,
          "requestFrom": record.requestFrom,
          "pin": record.pin.isEmpty ? "" : "******",
        })}');

    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json; odata=verbose',
              'Accept': 'application/json; odata=verbose',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[REGUSER_OTP_VALIDASI] STATUS: ${response.statusCode}');
      debugPrint('[REGUSER_OTP_VALIDASI] BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(
        success: false,
        data: "Gagal memvalidasi OTP.",
        rowcount: 0,
      );
    } on SocketException catch (e) {
      return _networkFailure('REGUSER_OTP_VALIDASI', e);
    } on TimeoutException catch (e) {
      return _networkFailure('REGUSER_OTP_VALIDASI', e);
    } on http.ClientException catch (e) {
      return _networkFailure('REGUSER_OTP_VALIDASI', e);
    } catch (e) {
      debugPrint('[REGUSER_OTP_VALIDASI] EXCEPTION: $e');
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
    final body = jsonEncode(record.toJson());

    debugPrint('[REGUSER_OTP_HP_STATUS] URI: $uri');
    debugPrint('[REGUSER_OTP_HP_STATUS] PAYLOAD: $body');

    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json; odata=verbose',
              'Accept': 'application/json; odata=verbose',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[REGUSER_OTP_HP_STATUS] STATUS: ${response.statusCode}');
      debugPrint('[REGUSER_OTP_HP_STATUS] BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(
        success: false,
        data: "Gagal mengecek status No. HP.",
        rowcount: 0,
      );
    } on SocketException catch (e) {
      return _networkFailure('REGUSER_OTP_HP_STATUS', e);
    } on TimeoutException catch (e) {
      return _networkFailure('REGUSER_OTP_HP_STATUS', e);
    } on http.ClientException catch (e) {
      return _networkFailure('REGUSER_OTP_HP_STATUS', e);
    } catch (e) {
      debugPrint('[REGUSER_OTP_HP_STATUS] EXCEPTION: $e');
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
    final body = jsonEncode(record.toJson());

    debugPrint('[REGUSER_OTP_PASSWORD_KIRIM] URI: $uri');
    debugPrint('[REGUSER_OTP_PASSWORD_KIRIM] PAYLOAD: $body');

    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json; odata=verbose',
              'Accept': 'application/json; odata=verbose',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[REGUSER_OTP_PASSWORD_KIRIM] STATUS: ${response.statusCode}');
      debugPrint('[REGUSER_OTP_PASSWORD_KIRIM] BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(
        success: false,
        data: "Gagal mengirim kata sandi.",
        rowcount: 0,
      );
    } on SocketException catch (e) {
      return _networkFailure('REGUSER_OTP_PASSWORD_KIRIM', e);
    } on TimeoutException catch (e) {
      return _networkFailure('REGUSER_OTP_PASSWORD_KIRIM', e);
    } on http.ClientException catch (e) {
      return _networkFailure('REGUSER_OTP_PASSWORD_KIRIM', e);
    } catch (e) {
      debugPrint('[REGUSER_OTP_PASSWORD_KIRIM] EXCEPTION: $e');
      return ReturnDataAPI(
        success: false,
        data: "Gagal mengirim kata sandi.",
        rowcount: 0,
      );
    }
  }
}
