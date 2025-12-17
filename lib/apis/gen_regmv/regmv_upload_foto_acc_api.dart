
import 'dart:convert';

import 'package:joss_app/common/app_data.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:flutter/material.dart';

class RegmvUploadFotoAccApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFotoAcc(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String filename,
      ) async {
    String endpoint = "api/regmv/regmv7form/uploadbinaryfotoacc";
    String url = _base + endpoint;

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    _dio.options.headers = headers;

    debugPrint("========== UPLOAD FOTO ACC START ==========");
    debugPrint("URL              : $url");
    debugPrint("regmv1Id         : $regmv1Id");
    debugPrint("filename         : $filename");
    debugPrint("bytes length     : ${imageBytes.lengthInBytes}");
    debugPrint("Token length     : ${AppData.userToken.length}");
    debugPrint("Token head       : ${AppData.userToken.substring(0, 12)}...");
    debugPrint("===========================================\n");

    try {
      final formData = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        'file': MultipartFile.fromBytes(imageBytes, filename: filename),
      });

      debugPrint("POSTING FORM DATA...");
      final response = await _dio.post(url, data: formData);

      debugPrint("\n========== RESPONSE UPLOAD ==========");
      debugPrint("Status code  : ${response.statusCode}");
      debugPrint("Body         : ${response.data.toString()}");
      debugPrint("======================================\n");

      if (response.statusCode == 200) {
        debugPrint("✔️ Upload ACC SUCCESS: $filename");
        return true;
      } else {
        debugPrint("❌ Upload ACC FAILED: $filename");
        return false;
      }

    } catch (e, stack) {
      debugPrint("❌ ERROR uploadFotoAcc");
      debugPrint("Error msg    : $e");
      debugPrint("Stack trace  : $stack");
      throw Exception('Gagal upload foto ACC: ${e.toString()}');
    }
  }
}