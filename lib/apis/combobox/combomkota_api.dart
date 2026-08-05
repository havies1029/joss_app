import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/combobox/combomkota_model.dart';

class ComboMKotaAPI {

	Future<List<ComboMKotaModel>> getComboMKotaAPI(String propinsiId, [String searchText = '']) async {
		String urlGetComboEndPoint = "${AppData.prefixEndPoint}/api/mkotacombobox/getlist";

    
    Map<String, String> queryParams = {
			"propinsiId": propinsiId,
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
				.map<ComboMKotaModel>((json) => ComboMKotaModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
