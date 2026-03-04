import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combombengkel_model.dart';

class ComboMBengkelAPI {

	Future<List<ComboMBengkelModel>> getComboMBengkelAPI(String mwilayahbengkelId, String filter) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mbengkelcombobox/getlist";

		Map<String, String> queryParams = {"mwilayahbengkelId": mwilayahbengkelId, "filter": filter};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<ComboMBengkelModel>((json) => ComboMBengkelModel.fromJson(json))
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
