import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';

class Klaim5cariAPI {
  Future<List<Klaim5cariModel>> getKlaim5cariAPI(String klaim1Id) async {
    try {
      final String urlGetListEndPoint =
          "${AppData.prefixEndPoint}/api/perbaruiklaimmv/klaim5cari/getlist";

      final Map<String, String> queryParams = {
        'klaim1Id': klaim1Id,
      };

      final Uri uri = AppData.uriHtpp(
        AppData.httpAuthority,
        urlGetListEndPoint,
        queryParams,
      );

      final headers = <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      };

      // DEBUG REQUEST
      debugPrint("========== GET KLAIM5CARI REQUEST ==========");
      debugPrint("METHOD : GET");
      debugPrint("URL    : $uri");
      debugPrint("PARAMS : $queryParams");
      debugPrint("HEADERS: $headers");
      debugPrint("============================================");

      final http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // DEBUG RESPONSE
      debugPrint("========== GET KLAIM5CARI RESPONSE =========");
      debugPrint("STATUS : ${response.statusCode}");
      debugPrint("REASON : ${response.reasonPhrase}");
      debugPrint("BODY   : ${response.body}");
      debugPrint("============================================");

      if (response.statusCode != 200) {
        throw Exception(
          "HTTP ${response.statusCode} ${response.reasonPhrase} | body: ${_short(response.body)}",
        );
      }

      final decoded = json.decode(response.body);

      debugPrint("========== GET KLAIM5CARI DECODED ==========");
      debugPrint("TYPE   : ${decoded.runtimeType}");
      debugPrint("DATA   : $decoded");
      debugPrint("============================================");

      if (decoded is! List) {
        throw Exception(
          "Response JSON bukan List. Tipe: ${decoded.runtimeType} | body: ${_short(response.body)}",
        );
      }

      final result = decoded
          .whereType<Map<String, dynamic>>()
          .map<Klaim5cariModel>((e) => Klaim5cariModel.fromJson(e))
          .toList();

      debugPrint("========== GET KLAIM5CARI RESULT ===========");
      debugPrint("TOTAL  : ${result.length}");
      debugPrint("============================================");

      return result;
    } on FormatException catch (e) {
      debugPrint("FORMAT EXCEPTION: ${e.message}");
      throw Exception("Parse JSON gagal: ${e.message}");
    } on http.ClientException catch (e) {
      debugPrint("CLIENT EXCEPTION: $e");
      throw Exception("HTTP Client error: $e");
    } catch (e, stackTrace) {
      debugPrint("GENERAL ERROR: $e");
      debugPrint("STACKTRACE: $stackTrace");
      throw Exception("Failed to load data: $e");
    }
  }

  String _short(String s, {int max = 250}) {
    if (s.length <= max) return s;
    return '${s.substring(0, max)}...';
  }
}
