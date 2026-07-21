import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';

class RegmvDownloadMobilApi {
  Future<http.Response> downloadFotoMobilApi(String regmv5Id) async {
    final url = Uri.parse(
        "${AppData.apiDomain}api/regmv/regmv5cari/fotomobil/download/$regmv5Id");

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
