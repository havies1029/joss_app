
import 'package:joss_app/common/app_data.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

class RegmvUploadStnkApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();
  Future<bool> uploadStnk(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String filename,
      ) async {
    String url = _base + "api/regmv/regmv4form/uploadbinaryfotostnk";

    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ${AppData.userToken}',
      };

      FormData formData = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        // 'file' harus sama dengan parameter di API
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
        ),
      });

      final response = await _dio.post(url, data: formData);

      return response.statusCode == 200;
    } catch (e) {
      print("❌ ERROR upload STNK => $e");
      return false;
    }
  }

}