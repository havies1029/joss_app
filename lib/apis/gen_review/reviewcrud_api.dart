import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_review/reviewcrud_model.dart';

class ReviewCrudAPI {
  Future<ReviewCrudModel> getReviewCrudAPI() async {
    String urlGetListEndPoint =
        "${AppData.prefixEndPoint}/api/review/reviewcrud/getconclusion";

    var uri = AppData.uriHtpp(
      AppData.httpAuthority,
      urlGetListEndPoint,
      {},
    );

    try {
      debugPrint("========== REVIEW CRUD REQUEST ==========");
      debugPrint("METHOD: GET");
      debugPrint("URL: $uri");
      debugPrint("HEADERS: ${{
        'Content-Type': 'application/json; odata=verbose',
        'Accept': 'application/json; odata=verbose',
        'Authorization': 'Bearer ${AppData.userToken}',
      }}");

      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
          'Authorization': 'Bearer ${AppData.userToken}',
        },
      );

      debugPrint("========== REVIEW CRUD RESPONSE ==========");
      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        debugPrint("DECODED TYPE: ${decoded.runtimeType}");
        debugPrint("DECODED VALUE: $decoded");

        if (decoded == null) {
          debugPrint("REVIEW CRUD WARNING: decoded is null");
          return ReviewCrudModel(nilai: 0, totalReview: 0, skala: 0);
        }

        if (decoded is List) {
          debugPrint("REVIEW CRUD LIST LENGTH: ${decoded.length}");

          if (decoded.isEmpty) {
            debugPrint("REVIEW CRUD WARNING: decoded list is empty");
            return ReviewCrudModel(nilai: 0, totalReview: 0, skala: 0);
          }

          debugPrint("REVIEW CRUD FIRST ITEM: ${decoded.first}");

          return ReviewCrudModel.fromJson(
            decoded.first as Map<String, dynamic>,
          );
        }

        if (decoded is Map<String, dynamic>) {
          debugPrint("REVIEW CRUD MAP KEYS: ${decoded.keys.toList()}");

          return ReviewCrudModel.fromJson(decoded);
        }

        throw Exception("Invalid response format: ${decoded.runtimeType}");
      } else {
        debugPrint("========== REVIEW CRUD ERROR RESPONSE ==========");
        debugPrint("STATUS CODE: ${response.statusCode}");
        debugPrint("BODY: ${response.body}");

        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e, s) {
      debugPrint("========== REVIEW CRUD EXCEPTION ==========");
      debugPrint("ERROR: $e");
      debugPrint("STACKTRACE: $s");
      rethrow;
    }
  }
}