import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_compro/reqcompro_model.dart';

class ReqComproAPI {
	Future<ReturnDataAPI> reqComproTambahAPI(ReqComproModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/compro/reqcomprocrud/create";
		Map<String, String> queryParams = {"modul_id": "reqComproTambahAPI"};
		var uri =
		AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		// 🔹 Debug: Tampilkan data sebelum dikirim
		print("🟦 [ReqComproAPI] START POST REQUEST");
		print("➡️ URL: $uri");
		print("➡️ Headers: ${{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}',
		}}");
		print("➡️ BODY:");
		print(const JsonEncoder.withIndent('  ').convert(record.toJson()));
		print("----------------------------------------------------");

		ReturnDataAPI returnData;
		try {
			final http.Response response = await http.post(
				uri,
				headers: {
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}',
				},
				body: jsonEncode(record.toJson()),
			);

			// 🔹 Debug: Response dari server
			print("🟩 [ReqComproAPI] RESPONSE STATUS: ${response.statusCode}");
			print("🟩 [ReqComproAPI] RESPONSE BODY:");
			print(response.body);
			print("----------------------------------------------------");

			if (response.statusCode == 200) {
				returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
			} else {
				print("⚠️ [ReqComproAPI] Non-200 status code received");
				returnData = ReturnDataAPI(success: false, data: response.body, rowcount: 0);
			}
		} catch (e, stacktrace) {
			print("❌ [ReqComproAPI] ERROR: $e");
			print("❌ [ReqComproAPI] STACKTRACE: $stacktrace");
			returnData = ReturnDataAPI(success: false, data: e.toString(), rowcount: 0);
		}

		print("🏁 [ReqComproAPI] END POST REQUEST");
		print("----------------------------------------------------");
		return returnData;
	}
}
