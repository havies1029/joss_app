import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:joss_app/common/app_data.dart';

class ImageUploaderStnk {
  static Future<bool> uploadBinary({
    required String regmv1Id,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final dio = Dio();

    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    final formData = FormData.fromMap({
      'regmv1Id': regmv1Id,
      'filename': fileName,
      'image_file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final url =
        "${AppData.apiDomain}api/regmv/regmv4form/uploadbinarystnk";

    final resp = await dio.post(url, data: formData);

    return resp.statusCode == 200;
  }
}
