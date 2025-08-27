import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/gen_aset_par/asetparcari_model.dart';

class AsetParCariAPI{
	Future<List<AsetParCariModel>> getAsetParCariAPI(String statusId, String searchText, int hal) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/assetpar/asetparcari/getlist";

		Map<String, String> queryParams = {"statusId": statusId, "searchText": searchText, "hal": hal.toString()};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});


		debugPrint('📥 STATUS CODE: ${response.statusCode}');
		debugPrint('🔗 GET URL: $uri');
		debugPrint('📄 BODY:\n${response.body}');

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
			// Tambahkan ini untuk lihat status tiap item:
			for (var item in parsed) {
				debugPrint('🧾 Item status: ${item["status"]}');
			}

			return parsed
				.map<AsetParCariModel>((json) => AsetParCariModel.fromJson(json))
				.toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
