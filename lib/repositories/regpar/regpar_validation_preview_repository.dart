import 'package:joss_app/apis/regpar/regpar_validation_preview_api.dart';
import 'package:joss_app/models/regpar/regpar_validation_preview_model.dart';

class RegparValidationPreviewRepository {
  final RegparValidationPreviewAPI api = RegparValidationPreviewAPI();

  Future<RegparValidationPreviewResponseModel> check(
    RegparValidationPreviewRequestModel record,
  ) async {
    return await api.check(record);
  }
}
