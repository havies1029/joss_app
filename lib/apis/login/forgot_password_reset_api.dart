import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/login/forgot_password_reset_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ForgotPasswordResetApi {
  Future<ReturnDataAPI> sendOtp(ForgotPasswordOtpSendModel record) async {
    final endpoint = '${AppData.prefixEndPoint}/api/forgot-password/otp/send';
    final queryParams = {'modul_id': 'forgotPasswordOtpSendAPI'};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    return _postReturnData(uri, record.toJson(), 'Gagal mengirim OTP.');
  }

  Future<ReturnDataAPI> validateOtp(
    ForgotPasswordOtpValidateModel record,
  ) async {
    final endpoint =
        '${AppData.prefixEndPoint}/api/forgot-password/otp/validate';
    final queryParams = {'modul_id': 'forgotPasswordOtpValidateAPI'};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    return _postReturnData(uri, record.toJson(), 'Gagal memvalidasi OTP.');
  }

  Future<ReturnDataAPI> resetPassword(ForgotPasswordResetModel record) async {
    final endpoint = '${AppData.prefixEndPoint}/api/forgot-password/reset';
    final queryParams = {'modul_id': 'forgotPasswordResetAPI'};
    final uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

    return _postReturnData(uri, record.toJson(), 'Gagal mereset password.');
  }

  Future<ReturnDataAPI> _postReturnData(
    Uri uri,
    Map<String, dynamic> body,
    String fallbackMessage,
  ) async {
    try {
      final response = await http.post(
        uri,
        headers: AppData.httpHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
      }

      return ReturnDataAPI(success: false, data: fallbackMessage, rowcount: 0);
    } catch (_) {
      return ReturnDataAPI(success: false, data: fallbackMessage, rowcount: 0);
    }
  }
}
