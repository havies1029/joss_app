import 'package:joss_app/apis/login/forgot_password_api.dart';
import 'package:joss_app/models/authentication/reset_password_model.dart';
import 'package:joss_app/models/login/forgot_password_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ForgotPasswordRepository {
  ForgotPasswordApi api = ForgotPasswordApi();

  Future<ReturnDataAPI> emailVerificationForgotPswd(ForgotPasswordModel record) async {
    return await api.emailVerificationForgotPswdAPI(record);
  }

  Future<ReturnDataAPI> validasiPinForgotPassword(ForgotPasswordModel record) async {
    return await api.validasiPinForgotPasswordAPI(record);
  }

  Future<bool> resetPassword(ResetPasswordModel pswd) async {
    return await api.resetPasswordApi(pswd);
  }
}
