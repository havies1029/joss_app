import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:joss_app/common/app_data.dart';

class ProfileKtpApi {
  final _base = AppData.apiDomain;
  final Dio _dio = Dio();

  Future<bool> uploadKtp(Uint8List imageBytes, String filename) async {
    String uploadKtpEndpoint = "api/userprofile/uploadktp";
    String uploadKtpURL = _base + uploadKtpEndpoint;

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    _dio.options.headers = headers;

    try {
      // Step 1: Upload file
      final uploadResponse = await _dio.post(
        uploadKtpURL,
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        }),
      );

      if (uploadResponse.statusCode == 200 &&
          uploadResponse.data['url'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Gagal mengambil gambar: ${e.toString()}');
    }
  }

  Future<bool> checkIsKtpUploaded(String mrekanId) async {    
		String getIsKTPUploadedEndpoint = "${AppData.prefixEndPoint}/api/profile/rekangeneralidvcrud/isktpuploaded";

		Map<String, String> queryParams = {'mrekanId': mrekanId};
    var uri = AppData.uriHtpp(AppData.httpAuthority, getIsKTPUploadedEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});


    if (response.statusCode == 200) {
      // Convert string response body to bool
      return json.decode(response.body) as bool;
    } else {
      throw Exception('Failed to check KTP upload status');
    }
  }


}
