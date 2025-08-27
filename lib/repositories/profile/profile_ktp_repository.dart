import 'dart:typed_data';

import 'package:joss_app/apis/profile/profile_ktp_api.dart';

class ProfileKtpRepository {
  Future<bool> uploadKtp(Uint8List imageBytes, String filename) {
    ProfileKtpApi api = ProfileKtpApi();
    return api.uploadKtp(imageBytes, filename);
  }

  Future<bool> checkIsKtpUploaded(String mrekanId) {
    ProfileKtpApi api = ProfileKtpApi();
    return api.checkIsKtpUploaded(mrekanId);
  }

}
