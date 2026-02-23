//generate from : usp_flutter_crud_api

import 'dart:convert';
import 'dart:io';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/dashboard/sumdash_model.dart';

class SumdashAPI {

  Future<SumdashModel?> sumdashLihatAPI() async {
    String lihatEndpoint = "${AppData.prefixEndPoint}/api/dashboard/sumdash/read";
    var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint);
    try{
      final http.Response response =
      await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}'
      });

      if (response.statusCode == 200) {
        var returnData = SumdashModel.fromJson(jsonDecode(response.body));
        return returnData;
      }
      if (response.statusCode == 404) {
        return null;
      }
      throw HttpException('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      throw Exception("Failed to load data: $e");
    }
  }
}