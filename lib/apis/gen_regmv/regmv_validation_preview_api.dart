import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:joss_app/models/gen_regmv/regmv_validation_preview_model.dart';

class RegmvValidationPreviewAPI {
  Future<RegmvValidationPreviewResponseModel> check(
    RegmvValidationPreviewRequestModel record,
  ) async {
    final endpoint =
        "${AppData.prefixEndPoint}/api/regmv/validation-preview/check";
    final queryParams = {"modul_id": "regmvValidationPreviewAPI"};
    final uri = AppData.uriHtpp(
      AppData.httpAuthority,
      endpoint,
      queryParams,
    );

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; odata=verbos',
          'Accept': 'application/json; odata=verbos',
          'Authorization': 'Bearer ${AppData.userToken}',
        },
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200) {
        ApiSideEffects.refreshHakakses();
        return RegmvValidationPreviewResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return RegmvValidationPreviewResponseModel.failure();
    } catch (_) {
      return RegmvValidationPreviewResponseModel.failure();
    }
  }
}
