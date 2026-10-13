import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';

class MRekanPicCrudAPI {
  Future<ReturnDataAPI> mRekanPicCrudTambahAPI(
      MRekanPicCrudModel record) async {
    String tambahEndpoint =
        "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/create";

    Map<String, String> queryParams = {"modul_id": "mRekanPicTambahAPI"};

    var uri = AppData.uriHtpp(
      AppData.httpAuthority,
      tambahEndpoint,
      queryParams,
    );

    ReturnDataAPI returnData;

    try {
      final bodyJson = jsonEncode(record.toJson());

      debugPrint("=== API REQUEST : mRekanPicCrudTambahAPI ===");
      debugPrint("URL      : $uri");
      debugPrint("METHOD   : POST");
      debugPrint("HEADERS  : Authorization Bearer ${AppData.userToken}");
      debugPrint("BODY     : $bodyJson");

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
        body: bodyJson,
      );

      debugPrint("=== API RESPONSE : mRekanPicCrudTambahAPI ===");
      debugPrint("STATUS CODE : ${response.statusCode}");
      debugPrint("BODY        : ${response.body}");

      if (response.statusCode != 200) {
        debugPrint("API ERROR STATUS : ${response.statusCode}");

        returnData = ReturnDataAPI(
          success: false,
          data: 'Gagal menambahkan PIC.',
          rowcount: 0,
        );
      } else if (response.body.trim().isEmpty ||
          response.body.trim() == 'null') {
        returnData = ReturnDataAPI(
          success: false,
          data: 'Server tidak mengembalikan hasil penambahan PIC.',
          rowcount: 0,
        );
      } else {
        final decoded = jsonDecode(response.body);
        if (decoded == null) {
          returnData = ReturnDataAPI(
            success: false,
            data: 'Server tidak mengembalikan hasil penambahan PIC.',
            rowcount: 0,
          );
        } else {
          returnData = ReturnDataAPI.fromDatabaseJson(decoded);
        }
      }
    } catch (e, stack) {
      debugPrint("=== API EXCEPTION : mRekanPicCrudTambahAPI ===");
      debugPrint("ERROR : $e");
      debugPrint("STACK : $stack");

      returnData = ReturnDataAPI(
        success: false,
        data: "",
        rowcount: 0,
      );
    }

    return returnData;
  }

  Future<ReturnDataAPI> mRekanPicCrudUbahAPI(MRekanPicCrudModel record) async {
    final ubahEndpoint =
        "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/update";

    final queryParams = {
      "modul_id": "mRekanPicUbahAPI",
    };

    final uri = AppData.uriHtpp(
      AppData.httpAuthority,
      ubahEndpoint,
      queryParams,
    );

    try {
      final body = jsonEncode(record.toJson());

      debugPrint("🚀 [API CALL] mRekanPicCrudUbahAPI");
      debugPrint("📍 URI : $uri");
      debugPrint("📦 BODY : $body");

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
          'Authorization': 'Bearer ${AppData.userToken}',
        },
        body: body,
      );

      debugPrint("📡 STATUS CODE : ${response.statusCode}");
      debugPrint("📥 RESPONSE BODY : ${response.body}");

      if (response.statusCode != 200) {
        return ReturnDataAPI(
          success: false,
          data: 'Gagal menyimpan perubahan data PIC.',
          rowcount: 0,
        );
      }

      if (response.body.trim().isEmpty || response.body.trim() == 'null') {
        return ReturnDataAPI(
          success: false,
          data: 'Server tidak mengembalikan hasil perubahan PIC.',
          rowcount: 0,
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        return ReturnDataAPI(
          success: false,
          data: 'Server tidak mengembalikan hasil perubahan PIC.',
          rowcount: 0,
        );
      }

      final returnData = ReturnDataAPI.fromDatabaseJson(decoded);

      debugPrint("✅ API SUCCESS : ${returnData.success}");

      return returnData;
    } catch (e, stackTrace) {
      debugPrint("❌ ERROR mRekanPicCrudUbahAPI : $e");
      debugPrint("📌 STACKTRACE : $stackTrace");
      return ReturnDataAPI(
        success: false,
        data: 'Terjadi kesalahan saat menyimpan perubahan PIC.',
        rowcount: 0,
      );
    }
  }

  Future<bool> mRekanPicCrudHapusAPI(String mrekanpicId) async {
    String hapusEndpoint =
        "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/delete";
    Map<String, String> queryParams = {
      'mrekanpicId': mrekanpicId,
      'modul_id': 'mRekanPicCrudHapusAPI'
    };
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    ReturnDataAPI returnData;
    if (response.statusCode == 200) {
      returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
    } else {
      returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
    }

    return returnData.success;
  }

  Future<MRekanPicCrudModel> mRekanPicCrudLihatAPI(String mrekanpicId) async {
    String lihatEndpoint =
        "${AppData.prefixEndPoint}/api/profile/mrekanpiccrud/read";
    Map<String, String> queryParams = {'mrekanpicId': mrekanpicId};
    var uri =
        AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    if (response.statusCode == 200) {
      var returnData = MRekanPicCrudModel.fromJson(jsonDecode(response.body));
      return returnData;
    } else {
      return throw Exception("Failed to load data");
    }
  }
}
