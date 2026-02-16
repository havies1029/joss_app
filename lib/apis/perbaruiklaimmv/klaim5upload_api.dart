import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

class Klaim5UploadFileApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadFileApi(String klaim1Id, Klaim5cariModel item) async {
    String uploadFileEndpoint = "api/perbaruiklaimmv/klaimmvdoccrud/uploadfile";
    String uploadFileURL = _base + uploadFileEndpoint;

    final file = File(item.localPath!);

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    _dio.options.headers = headers;

    try {
      // Step 1: Upload file
      final uploadResponse = await _dio.post(
        uploadFileURL,
        queryParameters: {
          'klaim1Id': klaim1Id,
        },
        data: FormData.fromMap({
          'klaim5Id': item.klaim5Id,
          'mjenisdocId': item.mjenisdocId,
          'jenisDocLain': item.jenisDocLain,
          'file': await MultipartFile.fromFile(
            file.path,
            filename: p.basename(file.path),
            contentType: DioMediaType.parse(item.mimeType??"application/octet-stream"),          ),
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