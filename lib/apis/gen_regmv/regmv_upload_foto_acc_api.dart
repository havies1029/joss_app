
import 'dart:convert';

import 'package:joss_app/common/app_data.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:flutter/material.dart';

class RegmvUploadFotoAccApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFotoAcc(String regmv1Id, String caption, Uint8List imageBytes, String filename) async {
    String uploadFotoAccEndpoint = "api/regmv/regmv7form/uploadbinaryfotoacc";
    String uploadFotoAccURL = _base + uploadFotoAccEndpoint;

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    _dio.options.headers = headers;

    try {
      // Step 1: Upload file
      final uploadResponse = await _dio.post(
        uploadFotoAccURL,
        data: FormData.fromMap({
          'regmv1Id': regmv1Id,
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
        debugPrint("Error uploading photo: ${e.toString()}");
        throw Exception('Gagal mengambil gambar: ${e.toString()}');
      }
    }
  }