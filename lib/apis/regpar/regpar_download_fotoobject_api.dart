import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/helper/api_side_effects.dart';

class RegparDownloadFotoObjectApi {
  Future<http.Response> downloadFotoObjectApi(String regpar6Id) async {
    final url = Uri.parse(
        "${AppData.apiDomain}api/regpar/regpar6cari/fotoobject/download/$regpar6Id");

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
