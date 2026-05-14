import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/layanan/mlayanan1cari_model.dart';

class Mlayanan1CariAPI{
	Future<List<Mlayanan1CariModel>> getMlayanan1CariAPI(String mlayanan1Id) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/layanan/mlayanan1cari/getlist";

		Map<String, String> queryParams = {
			"mlayanan1Id": mlayanan1Id,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		if (response.statusCode == 200) {
			final decoded = json.decode(response.body);

			if (decoded is List) {
				return decoded
						.map<Mlayanan1CariModel>(
							(json) => Mlayanan1CariModel.fromJson(json),
				)
						.toList();
			}

			if (decoded is Map<String, dynamic>) {
				return [
					Mlayanan1CariModel.fromJson(decoded),
				];
			}

			return <Mlayanan1CariModel>[];
		} else {
			throw Exception("Failed to load data");
		}
	}
}
