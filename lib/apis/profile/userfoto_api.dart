import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:http_parser/http_parser.dart';

final _base = AppData.apiDomain;
const _uploadFotoEndpoint = "api/userprofile/uploadfoto";
final _uploadFotoURL = _base + _uploadFotoEndpoint;

class UserFotoApi {
  Future<void> uploadImage2API(filepath) async {
    //debugPrint("uploadImage2API #10");

    UserRepository userRepo = UserRepository();
    String token = await userRepo.getToken();

    var request = http.MultipartRequest('POST', Uri.parse(_uploadFotoURL));

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };

    request.headers.addAll(headers);

    request.files
        .add(await http.MultipartFile.fromPath('image_file', filepath));
    await request.send();
  }

  Future<Uint8List?> getUserProfileFotoImageBytes() async {

    String getImageEndpoint = "${AppData.prefixEndPoint}/api/userprofile/getfoto";

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    var uri = AppData.uriHtpp(AppData.httpAuthority, getImageEndpoint);

    final response = await http.get(uri,headers: headers);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Gagal mengambil gambar: ${response.statusCode}');
    }
  }

  Future<Uint8List?> getUserProfileKtpImageBytes() async {

    String getImageEndpoint = "${AppData.prefixEndPoint}/api/userprofile/getktp";

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    var uri = AppData.uriHtpp(AppData.httpAuthority, getImageEndpoint);

    final response = await http.get(uri,headers: headers);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Gagal mengambil gambar: ${response.statusCode}');
    }
  }

  Future<void> postImage(File image) async {
    UserRepository userRepo = UserRepository();
    String token = await userRepo.getToken();

    String fileName = image.path.split('/').last;

    //debugPrint(fileName);

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        )
      });

      Map<String, String> headers = <String, String>{
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      };

      dio.options.headers = headers;

      await dio.post(_uploadFotoURL, data: formData);

      /*
    if (response.statusCode == 200) {
      debugPrint("Uploaded");
    } else {
      debugPrint(response.data);
    }
    debugPrint('Out');
    */
    } catch (e) {
      //debugPrint(e.toString());
    }
  }
}
