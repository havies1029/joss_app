import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';

class DownloadPolisApi {
  Future<http.Response> downloadPolisApi(String ePolisId) async {
    final url = Uri.parse("${AppData.apiDomain}api/sppamv/epolis/download/$ePolisId");

    // 🔍 DEBUG REQUEST
    debugPrint("REQUEST URL => $url");
    debugPrint("REQUEST METHOD => GET");
    debugPrint("REQUEST HEADERS => Authorization: Bearer ${AppData.userToken}");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${AppData.userToken}",
      },
    );

    // 🔍 DEBUG RESPONSE
    debugPrint("STATUS CODE => ${response.statusCode}");
    debugPrint("RESPONSE HEADERS => ${response.headers}");
    debugPrint("RESPONSE BODY => ${response.body}");

    return response;
  }


}