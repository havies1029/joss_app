import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combominsurer_model.dart';

class ComboMInsurerAPI {

	Future<List<ComboMInsurerModel>> getComboMInsurerAPI(String filter) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/minsurercombobox/getlist";

		Map<String, String> queryParams = {"filter": filter};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<ComboMInsurerModel>((json) => ComboMInsurerModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
