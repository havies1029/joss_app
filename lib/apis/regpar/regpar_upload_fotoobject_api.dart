import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';

class RegparUploadFotoObjectApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<ReturnDataAPI> uploadFotoObject(
    String regpar1Id,
    String caption,
    Uint8List imageBytes,
    String filename,
  ) async {
    const endpoint = "api/regpar/regpar6form/uploadbinaryfotoobject";
    final url = _base + endpoint;

    _dio.options.headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    try {
      final resp = await _dio.post(
        url,
        data: FormData.fromMap({
          'regpar1Id': regpar1Id,
          'caption': caption,
          'filename': filename,
          'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        }),
      );

      if (resp.statusCode == 200) {
        ApiSideEffects.refreshHakakses();
        final data = _asMap(resp.data);
        return ReturnDataAPI.fromDatabaseJson(data);
      } else {
        return ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } catch (e) {
      debugPrint("Error uploading photo: ${e.toString()}");
      // samain gaya kamu: lempar exception
      throw Exception('Gagal upload foto: ${e.toString()}');
    }
  }

  Future<ReturnDataAPI> uploadFotoObjectByPath(
    String regpar1Id,
    String caption,
    String filePath,
    String filename,
  ) async {
    const endpoint = "api/regpar/regpar6form/uploadbinaryfotoobject";
    final url = _base + endpoint;

    _dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}',
    };

    try {
      final form = FormData.fromMap({
        'regpar1Id': regpar1Id,
        'caption': caption,
        'filename': filename,
        'file': await MultipartFile.fromFile(filePath, filename: filename),
      });

      final resp = await _dio.post(url, data: form);

      if (resp.statusCode == 200) {
        ApiSideEffects.refreshHakakses();
        final data = _asMap(resp.data);
        debugPrint("parsed map: $data");
        return ReturnDataAPI.fromDatabaseJson(data);
      } else {
        return ReturnDataAPI(success: false, data: "", rowcount: 0);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error uploading photo: $e");
      rethrow;
    }
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
    // fallback aman
    return <String, dynamic>{};
  }
}
