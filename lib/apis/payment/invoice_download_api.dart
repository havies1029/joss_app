import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../common/app_data.dart';

class InvoiceDownloadApi {
  static String? _token = "MjAyNTEySk9TUzAzOlhQb29mSDZneXZ2T2t4cDZWZEVzVlE9PQ==";

  static void setToken(String token) {
    _token = token.trim();
  }

  static void clearToken() {
    _token = null;
  }

  String _bearerToken() {
    if (_token == null || _token!.isEmpty) {
      throw Exception(
          "Token belum diset. Panggil InvoiceDownloadApi.setToken(token) dulu.");
    }
    return "Bearer $_token";
  }

  Future<http.Response> downloadInvoice(String noInv) async {
    try {
      final uri = Uri.https(
        AppData.adminApiAuthority,
        '/api/inv/download',
        {
          'no_inv': noInv,
          'user_id': AppData.user.username.toString(),
        },
      );

      final headers = {
        "Authorization": _bearerToken(),
        "Accept": "image/*",
      };

      // REQUEST
      debugPrint("========== DOWNLOAD INVOICE REQUEST ==========");
      debugPrint("URL      : $uri");
      debugPrint("METHOD   : GET");
      debugPrint("HEADERS  : $headers");
      debugPrint("PARAMS   : no_inv=$noInv");

      final response = await http.get(
        uri,
        headers: headers,
      );

      // RESPONSE
      debugPrint("========== DOWNLOAD INVOICE RESPONSE ==========");
      debugPrint("STATUS   : ${response.statusCode}");
      debugPrint("HEADERS  : ${response.headers}");

      if (response.body.length < 5000) {
        debugPrint("BODY     : ${response.body}");
      } else {
        debugPrint("BODY     : <binary/image data length=${response.bodyBytes
            .length}>");
      }

      return response;
    } catch (e, st) {
      debugPrint("========== DOWNLOAD INVOICE ERROR ==========");
      debugPrint("ERROR    : $e");
      debugPrint("STACK    : $st");
      rethrow;
    }
  }
}