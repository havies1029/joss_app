import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_stnk_api.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegmvUploadStnkRepository {
  Future<ReturnDataAPI> uploadStnk(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String fileName,
      ) async {
    final api = RegmvUploadStnkApi();
    return api.uploadStnk(regmv1Id, caption, imageBytes, fileName);
  }

  Future<ReturnDataAPI> uploadStnkByPath(
      String regmv1Id,
      String caption,
      String filePath,
      String fileName,
      ) async {
    final api = RegmvUploadStnkApi();
    return api.uploadStnkByPath(regmv1Id, caption, filePath, fileName);
  }
}