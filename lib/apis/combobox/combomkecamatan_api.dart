import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';

class ComboMKecamatanAPI {

	Future<List<ComboMKecamatanModel>> getComboMKecamatanAPI(String kotaId, [String searchText = '']) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mkecamatancombobox/getlist";

    Map<String, String> queryParams = {
			"kotaId": kotaId,
			"searchText": searchText,
		};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetComboEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
				.map<ComboMKecamatanModel>((json) => ComboMKecamatanModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
