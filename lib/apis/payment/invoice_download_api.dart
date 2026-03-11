import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
      throw Exception("Token belum diset. Panggil InvoiceDownloadApi.setToken(token) dulu.");
    }
    return "Bearer $_token";
  }

  Future<http.Response> downloadInvoice(String noInv) async {
    final uri = Uri.https(
      'jossadminapi.smartsoft-id.com',
      '/api/inv/download',
      {'no_inv': noInv},
    );

    final response = await http.get(
      uri,
      headers: {
        "Authorization": _bearerToken(), // 🔥 token dari dalam class ini
        "Accept": "image/*",
      },
    );

    // 🔍 DEBUG
    debugPrint("====== DOWNLOAD INVOICE DEBUG ======");
    debugPrint("URL         : $uri");
    debugPrint("TOKEN LEN   : ${_token?.length}");
    debugPrint("STATUS CODE : ${response.statusCode}");
    debugPrint("CONTENTTYPE : ${response.headers['content-type']}");
    debugPrint("HEADERS     : ${response.headers}");
    debugPrint("BODY STRING : ${response.body}"); // kalau json error bakal kebaca
    debugPrint("BODY BYTES  : ${response.bodyBytes.length} bytes");
    debugPrint("====================================");

    return response;
  }
}
