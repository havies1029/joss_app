import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/gen_detail_sts_sppa/mdetailstssppacari_model.dart';

class MDetailStsSppaCariAPI {
  Future<List<MDetailStsSppaCariModel>> getMDetailStsSppaCariAPI() async {
    String urlGetListEndPoint =
        "${AppData.prefixEndPoint}/api/mdetailstssppa/mdetailstssppacari/getlist";

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}'
      },
    );

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<MDetailStsSppaCariModel>(
              (json) => MDetailStsSppaCariModel.fromJson(json))
          .toList();
    } else {
      throw Exception(
          "Failed to load data detail sts sppa cari: ${response.statusCode}");
    }
  }
}
