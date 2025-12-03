import 'dart:typed_data';

import 'package:joss_app/apis/gen_regmv/regmv_upload_stnk_api.dart';

class RegmvUploadStnkRepository {
  Future<bool> uploadStnk(String regmv1Id, String caption, Uint8List imageBytes, String fileName) async {

    RegmvUploadStnkApi api = RegmvUploadStnkApi();
    return api.uploadStnk(regmv1Id, caption, imageBytes, fileName);
  }
}