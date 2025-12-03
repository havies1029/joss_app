import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_foto_acc_api.dart';

class RegmvUploadFotoAccRepository {
  Future<bool> uploadFotoAcc(String regmv1Id, String caption, Uint8List imageBytes, String fileName) async {

    RegmvUploadFotoAccApi api = RegmvUploadFotoAccApi();
    return api.uploadFotoAcc(regmv1Id, caption, imageBytes, fileName);
  }
}