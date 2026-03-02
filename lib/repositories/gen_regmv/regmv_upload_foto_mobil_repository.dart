import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_foto_mobil_api.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegmvUploadFotoMobilRepository {
  Future<ReturnDataAPI> uploadFotoMobil(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String fileName,
      ) async {
    final api = RegmvUploadFotoMobilApi();
    return api.uploadFotoMobil(regmv1Id, caption, imageBytes, fileName);
  }

  Future<ReturnDataAPI> uploadFotoMobilByPath(
      String regmv1Id,
      String caption,
      String filePath,
      String fileName,
      ) async {
    final api = RegmvUploadFotoMobilApi();
    return api.uploadFotoMobilByPath(regmv1Id, caption, filePath, fileName);
  }
}