import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_foto_acc_api.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegmvUploadFotoAccRepository {
  Future<ReturnDataAPI> uploadFotoAcc(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String fileName,
      ) async {
    final api = RegmvUploadFotoAccApi();
    return api.uploadFotoAcc(regmv1Id, caption, imageBytes, fileName);
  }

  Future<ReturnDataAPI> uploadFotoAccByPath(
      String regmv1Id,
      String caption,
      String filePath,
      String fileName,
      ) async {
    final api = RegmvUploadFotoAccApi();
    return api.uploadFotoAccByPath(regmv1Id, caption, filePath, fileName);
  }
}