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
      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbose',
          'Accept': 'application/json; odata=verbose',
          'Authorization': 'Bearer ${AppData.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded == null) {
          return ReviewCrudModel(nilai: 0, totalReview: 0, skala: 0);
        }

        if (decoded is List) {
          if (decoded.isEmpty) {
            return ReviewCrudModel(nilai: 0, totalReview: 0, skala: 0);
          }

          return ReviewCrudModel.fromJson(
            decoded.first as Map<String, dynamic>,
          );
        }

        if (decoded is Map<String, dynamic>) {
          return ReviewCrudModel.fromJson(decoded);
        }

        throw Exception("Invalid response format: ${decoded.runtimeType}");
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e, s) {
      debugPrint("ERROR: $e");
      debugPrint("STACKTRACE: $s");
      rethrow;
    }
  }
}