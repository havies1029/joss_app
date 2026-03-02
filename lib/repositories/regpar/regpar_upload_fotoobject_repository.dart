import 'dart:typed_data';

import 'package:joss_app/apis/regpar/regpar_upload_fotoobject_api.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegparUploadFotoObjectRepository {
  Future<ReturnDataAPI> uploadFotoObject(
      String regpar1Id,
      String caption,
      Uint8List imageBytes,
      String fileName,
      ) async {
    final api = RegparUploadFotoObjectApi();
    return api.uploadFotoObject(regpar1Id, caption, imageBytes, fileName);
  }

  Future<ReturnDataAPI> uploadFotoObjectByPath(
      String regpar1Id,
      String caption,
      String filePath,
      String fileName,
      ) async {
    final api = RegparUploadFotoObjectApi();
    return api.uploadFotoObjectByPath(regpar1Id, caption, filePath, fileName);
  }
}