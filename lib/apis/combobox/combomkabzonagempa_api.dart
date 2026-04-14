import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';

class ComboMKabZonaGempaAPI {
	Future<List<ComboMKabZonaGempaModel>> getComboMKabZonaGempaAPI(
			String wilayahId,
			String searchText,
			) async {
		String urlGetComboEndPoint =
				"${AppData.prefixEndPoint}/api/mkabzonagempacombobox/getlist";

		final uri = Uri.parse(
			"http://${AppData.httpAuthority}$urlGetComboEndPoint",
		).replace(
			queryParameters: {
				"wilayahId": wilayahId,
				"searchText": searchText,
			},
		);

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbose',
				'Accept': 'application/json; odata=verbose',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			return parsed
					.map<ComboMKabZonaGempaModel>(
						(json) => ComboMKabZonaGempaModel.fromJson(json),
			)
					.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
