import 'package:joss_app/apis/reguser/reguser_otp_api.dart';
import 'package:joss_app/models/reguser/reguser_otp_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class ReguserOtpRepository {
  final ReguserOtpApi api;

  ReguserOtpRepository({ReguserOtpApi? api}) : api = api ?? ReguserOtpApi();

  Future<ReturnDataAPI> kirim(ReguserOtpSendModel record) {
    return api.kirim(record);
  }

  Future<ReturnDataAPI> validasi(ReguserOtpValidateModel record) {
    return api.validasi(record);
  }

  Future<ReturnDataAPI> hpStatus(ReguserOtpHpRequestModel record) {
    return api.hpStatus(record);
  }

  Future<ReturnDataAPI> kirimPassword(ReguserOtpHpRequestModel record) {
    return api.kirimPassword(record);
  }
}
