
import 'package:joss_app/apis/login/change_password_api.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';

class ChangePasswordRepository {
  ChangePasswordApi api = ChangePasswordApi();
  Future<bool> changePassword(ChangePasswordModel pswd) async {
    return await api.changePasswordApi(pswd);
  }
}
