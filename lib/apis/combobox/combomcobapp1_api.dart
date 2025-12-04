import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import '../../models/combobox/combomcobapp1_model.dart';

class ComboMCobApp1API {

  Future<List<ComboMCobApp1Model>> getComboMCobApp1API() async {
    String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mcobapp1combobox/getlist";

    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint);
    final http.Response response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; odata=verbos',
      'Accept': 'application/json; odata=verbos',
      'Authorization': 'Bearer ${AppData.userToken}'
    });

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ComboMCobApp1Model>((json) => ComboMCobApp1Model.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}
