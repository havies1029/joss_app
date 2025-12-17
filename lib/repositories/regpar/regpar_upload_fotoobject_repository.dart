import 'dart:typed_data';

import 'package:joss_app/apis/regpar/regpar_upload_fotoobject_api.dart';

class RegparUploadFotoObjectRepository {
  Future<bool> uploadFotoObject(String regpar1Id, String caption, Uint8List imageBytes, String fileName) async {

    RegparUploadFotoObjectApi api = RegparUploadFotoObjectApi();
    return api.uploadFotoObject(regpar1Id, caption, imageBytes, fileName);
  }
}