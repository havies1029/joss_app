import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combompropinsi_model.dart';

class ComboMPropinsiAPI {

	Future<List<ComboMPropinsiModel>> getComboMPropinsiAPI(String filter) async {
    Map<String, String> queryParams = {"filter": filter};
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mpropinsicombobox/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<ComboMPropinsiModel>((json) => ComboMPropinsiModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
