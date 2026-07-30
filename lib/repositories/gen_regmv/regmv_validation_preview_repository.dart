import 'package:joss_app/apis/gen_regmv/regmv_validation_preview_api.dart';
import 'package:joss_app/models/gen_regmv/regmv_validation_preview_model.dart';

class RegmvValidationPreviewRepository {
  final RegmvValidationPreviewAPI api = RegmvValidationPreviewAPI();

  Future<RegmvValidationPreviewResponseModel> check(
    RegmvValidationPreviewRequestModel record,
  ) async {
    return await api.check(record);
  }
}
