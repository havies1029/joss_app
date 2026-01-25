import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/app_data.dart';

class RegmvUploadFotoAccApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFotoAcc(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String filename,
      ) async {
    const endpoint = "api/regmv/regmv7form/uploadbinaryfotoacc";
    final url = _base + endpoint;

    _dio.options.headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    try {
      final formData = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        'file': MultipartFile.fromBytes(imageBytes, filename: filename),
      });

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        debugPrint("UPLOAD FOTO ACC RESPONSE BODY: ${response.data}");
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Gagal upload foto ACC: ${e.toString()}');
    }
  }
}
