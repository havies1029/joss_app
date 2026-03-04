
import 'dart:typed_data';

import 'package:joss_app/apis/regklaim/regklaim2_upload_file_api.dart';

class Regklaim2UploadFileRepository {
  Future<bool> uploadFile(String regklaim1Id, String caption, Uint8List imageBytes, String fileName) async {

    Regklaim2UploadFileApi api = Regklaim2UploadFileApi();
    return api.uploadFile(regklaim1Id, caption, imageBytes, fileName);
  }
}