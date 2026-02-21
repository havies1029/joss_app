import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';

class KlaimprogresscariAPI{
	Future<KlaimprogressCariResultModel> getKlaimprogresscariAPI(String klaim1Id) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/klaimlacak/klaimprogresscari/getlist";

    Map<String, String> queryParams = {"klaim1Id": klaim1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final decoded = jsonDecode(response.body);
			if (decoded is! Map<String, dynamic>) {
				throw Exception('Unexpected JSON type: ${decoded.runtimeType}');
			}

      var result = KlaimprogressCariResultModel.fromJson(decoded);

			return result;
		} else {
			throw Exception("Failed to load data");
		}
	}

}
