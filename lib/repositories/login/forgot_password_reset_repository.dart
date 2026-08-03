import 'package:joss_app/apis/login/forgot_password_reset_api.dart';
import 'package:joss_app/models/login/forgot_password_reset_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ForgotPasswordResetRepository {
  final ForgotPasswordResetApi api;

  ForgotPasswordResetRepository({ForgotPasswordResetApi? api})
      : api = api ?? ForgotPasswordResetApi();

  Future<ReturnDataAPI> sendOtp(ForgotPasswordOtpSendModel record) {
    return api.sendOtp(record);
  }

  Future<ReturnDataAPI> validateOtp(ForgotPasswordOtpValidateModel record) {
    return api.validateOtp(record);
  }

  Future<ReturnDataAPI> resetPassword(ForgotPasswordResetModel record) {
    return api.resetPassword(record);
  }
}
