import 'package:joss_app/apis/login/forgot_password_api.dart';
import 'package:joss_app/models/authentication/reset_password_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ForgotPasswordRepository {
  ForgotPasswordApi api = ForgotPasswordApi();

  Future<ReturnDataAPI> requestOtp(RequestOtpModel record) async {
    return await api.requestOtpAPI(record);
  }

  Future<ReturnDataAPI> validasiOtp(RequestOtpModel record) async {
    return await api.validasiOtpAPI(record);
  }

  Future<ReturnDataAPI> resendOtp(RequestOtpModel record) async {
    return await api.resendOtpAPI(record);
  }

  Future<bool> resetPassword(ResetPasswordModel pswd) async {
    return await api.resetPasswordApi(pswd);
  }
}
