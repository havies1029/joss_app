

import 'package:joss_app/common/app_data.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Regklaim2UploadFileApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFile(String regklaim1Id, String caption, Uint8List imageBytes, String filename) async {
    String uploadFileEndpoint = "api/regklaim/regklaim1crud/uploadbinaryfile";
    String uploadFileURL = _base + uploadFileEndpoint;

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    _dio.options.headers = headers;

    try {
      // Step 1: Upload file
      final uploadResponse = await _dio.post(
        uploadFileURL,
        data: FormData.fromMap({
          'regklaim1Id': regklaim1Id,
          'caption': caption,
          'filename': filename,
          'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        }),
      );

      if (uploadResponse.statusCode == 200) {            
        return true;
      } else {
        return false;
      }
      } catch (e) {
        debugPrint("Error uploading file: ${e.toString()}");
        throw Exception('Gagal mengambil file: ${e.toString()}');
      }
    }
  }