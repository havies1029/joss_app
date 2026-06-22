import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/helper/object_map_helper.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';

class KlaimprogresscariAPI{

	Future<KlaimprogressCariResultModel?> getKlaimprogresscariAPI(String klaim1Id) async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/klaimlacak/klaimprogresscari/getlist";

		Map<String, String> queryParams = {
			"klaim1Id": klaim1Id,
		};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		debugPrint("=== getKlaimprogresscariAPI REQUEST ===");
		debugPrint("klaim1Id: $klaim1Id");
		debugPrint("URL: $uri");
		debugPrint("Headers: {Content-Type: application/json; odata=verbos, Accept: application/json; odata=verbos, Authorization: Bearer ***}");

		try {
			final http.Response response = await http.get(
				uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
			);

			debugPrint("=== getKlaimprogresscariAPI RESPONSE ===");
			debugPrint("StatusCode: ${response.statusCode}");
			debugPrint("Body: ${response.body}");

			if (response.statusCode == 200) {
				final jsonData = ObjectMapHelper().decodeJsonMapOrNull(response.body);

				debugPrint("Decoded jsonData: $jsonData");

				if (jsonData == null) {
					debugPrint("jsonData is null");
					return null;
				}

				var result = KlaimprogressCariResultModel.fromJson(jsonData);

				debugPrint("Parsed result: $result");

				return result;
			} else {
				debugPrint("Failed getKlaimprogresscariAPI");
				debugPrint("StatusCode: ${response.statusCode}");
				debugPrint("Error Body: ${response.body}");

				throw Exception("Failed to load data");
			}
		} catch (e, stackTrace) {
			debugPrint("=== getKlaimprogresscariAPI ERROR ===");
			debugPrint("Error: $e");
			debugPrint("StackTrace: $stackTrace");
			rethrow;
		}
	}
}
