import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';

class DownloadPolisApi {
  Future<http.Response> downloadPolisApi(String ePolisId) async {
    final url = Uri.parse("${AppData.apiDomain}api/sppamv/epolis/download/$ePolisId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${AppData.userToken}",
      },
    );
    return response;
  }


}