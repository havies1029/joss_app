import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combominsurance2_model.dart';

class ComboMInsurance2API {
	Future<List<ComboMInsurance2Model>> getComboMInsurance2API(String filter) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/minsurancecombobox2/getlist";

		Map<String, String> queryParams = {"filter": filter};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<ComboMInsurance2Model>((json) => ComboMInsurance2Model.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
