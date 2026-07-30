import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';
import 'package:joss_app/models/regpar/regpar_validation_preview_model.dart';

class RegparValidationPreviewAPI {
  Future<RegparValidationPreviewResponseModel> check(
    RegparValidationPreviewRequestModel record,
  ) async {
    final endpoint =
        "${AppData.prefixEndPoint}/api/regpar/validation-preview/check";
    final queryParams = {"modul_id": "regparValidationPreviewAPI"};
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
        return RegparValidationPreviewResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return RegparValidationPreviewResponseModel.failure();
    } catch (_) {
      return RegparValidationPreviewResponseModel.failure();
    }
  }
}
