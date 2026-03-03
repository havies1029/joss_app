import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegmvUploadFotoAccApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<ReturnDataAPI> uploadFotoAcc(
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
      final resp = await _dio.post(
        url,
        data: FormData.fromMap({
          'regmv1Id': regmv1Id,
          'caption': caption,
          'filename': filename,
          'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        }),
      );

      if (resp.statusCode == 200) {
        final data = _asMap(resp.data);
        return ReturnDataAPI.fromDatabaseJson(data);
      } else {
        return ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } catch (e) {
      debugPrint("Error uploading photo ACC: ${e.toString()}");
      throw Exception('Gagal upload foto ACC: ${e.toString()}');
    }
  }

  Future<ReturnDataAPI> uploadFotoAccByPath(
      String regmv1Id,
      String caption,
      String filePath,
      String filename,
      ) async {
    const endpoint = "api/regmv/regmv7form/uploadbinaryfotoacc";
    final url = _base + endpoint;

    _dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    try {
      final form = FormData.fromMap({
        'regmv1Id': regmv1Id,
        'caption': caption,
        'filename': filename,
        'file': await MultipartFile.fromFile(filePath, filename: filename),
      });

      final resp = await _dio.post(url, data: form);

      if (resp.statusCode == 200) {
        final data = _asMap(resp.data);
        return ReturnDataAPI.fromDatabaseJson(data);
      } else {
        return ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } on DioException {

      rethrow;
    } catch (e) {
      debugPrint("Error uploading photo ACC: $e");
      rethrow;
    }
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
    return <String, dynamic>{};
  }
}