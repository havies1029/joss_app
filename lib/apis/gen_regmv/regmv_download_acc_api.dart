import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';

class RegmvDownloadAccApi {
  Future<http.Response> downloadFotoAccApi(String regmv7Id) async {
    final url = Uri.parse(
        "${AppData.apiDomain}api/regmv/regmv7cari/fotoacc/download/$regmv7Id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${AppData.userToken}",
      },
    );

    ApiSideEffects.refreshHakaksesOnHttpStatus(response.statusCode);

    return response;
  }
}
