
import 'dart:convert';

import 'package:joss_app/common/app_data.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:flutter/material.dart';

class RegmvUploadFotoMobilApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFotoMobil(
      String regmv1Id,
      String caption,
      Uint8List imageBytes,
      String filename,
      ) async {

    String uploadFotoMobilEndpoint =
        "api/regmv/regmv5form/uploadbinaryfotomobil";
    String url = _base + uploadFotoMobilEndpoint;

    // 🔥 DEBUG TOKEN
    debugPrint("========== UPLOAD FOTO MOBIL ==========");
    debugPrint("URL          : $url");
    debugPrint("regmv1Id     : $regmv1Id");
    debugPrint("caption      : '$caption'");
    debugPrint("filename     : $filename");
    debugPrint("bytes        : ${imageBytes.lengthInBytes}");
    debugPrint("TOKEN LENGTH : ${AppData.userToken.length}");
    debugPrint("TOKEN HEAD   : ${AppData.userToken.substring(0, 15)}...");
    debugPrint("----------------------------------------");

    // HEADER
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    _dio.options.headers = headers;

    try {
      // 🔥 DEBUG FORM DATA
      final formData = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
        ),
      });

      debugPrint("FORM DATA:");
      debugPrint(" - regmv1Id: $regmv1Id");
      debugPrint(" - caption : $caption");
      debugPrint(" - filename: $filename");
      debugPrint(" - fileBytes: ${imageBytes.lengthInBytes}");
      debugPrint("----------------------------------------");

      // 🔥 CALL API
      final response = await _dio.post(url, data: formData);

      debugPrint("📥 RESPONSE:");
      debugPrint(" - Status Code : ${response.statusCode}");
      debugPrint(" - Data        : ${response.data}");
      debugPrint("========================================");

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("⚠️ Upload gagal: status ${response.statusCode}");
        return false;
      }

    } catch (e) {
      debugPrint("❌ DIO ERROR saat upload foto mobil:");
      debugPrint("Error detail: ${e.toString()}");

      if (e is DioException) {
        debugPrint("---- DIO EXCEPTION DETAILS ----");
        debugPrint("Type     : ${e.type}");
        debugPrint("Message  : ${e.message}");
        debugPrint("Response : ${e.response}");
        debugPrint("Status   : ${e.response?.statusCode}");
        debugPrint("Data     : ${e.response?.data}");
        debugPrint("--------------------------------");
      }

      return false;
    }
  }

}