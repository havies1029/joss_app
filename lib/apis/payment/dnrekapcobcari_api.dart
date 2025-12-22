import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/payment/dnrekapcobcari_model.dart';

class DnrekapcobCariAPI{
	Future<List<DnrekapcobCariModel>> getDnrekapcobCariAPI() async {
		String urlGetListEndPoint =
				"${AppData.prefixEndPoint}/api/payment/dnrekapcobcari/getlist";

		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);

		debugPrint("➡️ [Dnrekapcob] GET: $uri");
		debugPrint("   Token: ${AppData.userToken}");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		debugPrint("⬅️ [Dnrekapcob] Status: ${response.statusCode}");
		debugPrint("⬅️ [Dnrekapcob] Raw Body: ${response.body}");

		if (response.statusCode == 200) {
			final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

			debugPrint("📦 [Dnrekapcob] Parsed Count: ${parsed.length}");

			return parsed
					.map<DnrekapcobCariModel>(
							(json) => DnrekapcobCariModel.fromJson(json))
					.toList();
		} else {
			debugPrint("❌ [Dnrekapcob] Failed to load data");
			throw Exception("Failed to load data");
		}
	}

}
