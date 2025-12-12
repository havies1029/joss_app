import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';

class RegmvDownloadStnkApi {

  Future<http.Response> downloadStnkApi(String regmv4Id) async {
    final url = Uri.parse("${AppData.apiDomain}api/regmv/regmv4cari/stnk/download/$regmv4Id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${AppData.userToken}",
      },
    );

    return response;
  }


}