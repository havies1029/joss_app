
import 'package:flutter/cupertino.dart';
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
    String url = "${_base}api/regmv/regmv4form/uploadbinaryfotostnk";

    debugPrint("");
    debugPrint("🟦================ UPLOAD STNK START ================");
    debugPrint("🌍 URL: $url");
    debugPrint("📌 Header Auth: Bearer ${AppData.userToken.substring(0, 10)}...");

    debugPrint("📄 Data Body:");
    debugPrint("   ├─ regmv1Id : $regmv1Id");
    debugPrint("   ├─ caption  : '$caption'");
    debugPrint("   ├─ filename : $filename");
    debugPrint("   └─ bytes    : ${imageBytes.lengthInBytes} bytes");

    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ${AppData.userToken}',
      };

      FormData formData = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
        ),
      });

      debugPrint("📤 Mengirim FormData...");
      debugPrint("   └─ fields: ${formData.fields}");
      debugPrint("   └─ files : 1 file attached");

      final response = await _dio.post(url, data: formData);

      debugPrint("📥 Response STNK Upload:");
      debugPrint("   ├─ statusCode: ${response.statusCode}");
      debugPrint("   └─ body: ${response.data}");

      final success = response.statusCode == 200;

      debugPrint("🟩 Upload Result => $success");
      debugPrint("🟦================= UPLOAD STNK END =================");
      debugPrint("");

      return success;

    } catch (e) {
      debugPrint("🟥 ERROR upload STNK => $e");
      debugPrint("🟥===============================================");
      return false;
    }
  }

}