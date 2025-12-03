import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_foto_mobil_api.dart';

class RegmvUploadFotoMobilRepository {
  Future<bool> uploadFotoMobil(String regmv1Id, String caption, Uint8List imageBytes, String fileName) async {

    RegmvUploadFotoMobilApi api = RegmvUploadFotoMobilApi();
    return api.uploadFotoMobil(regmv1Id, caption, imageBytes, fileName);
  }
}