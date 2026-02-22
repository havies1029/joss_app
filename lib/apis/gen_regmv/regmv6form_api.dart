import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';

class Regmv6FormAPI {

	Future<ReturnDataAPI> regmv6FormTambahAPI(Regmv6FormModel record) async {
		String tambahEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv6form/create";
		Map<String, String> queryParams = {"modul_id": "regmv6FormTambahAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		ReturnDataAPI returnData;
		final http.Response response = await http.post(uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData;
	}
	Future<bool> regmv6FormUbahAPI(Regmv6FormModel record) async {
		String ubahEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv6form/update";
		Map<String, String> queryParams = {"modul_id": "regmv6FormUbahAPI"};

		var uri = AppData.uriHtpp(AppData.httpAuthority, ubahEndpoint, queryParams);

		final http.Response response = await http.post(uri,
				headers: <String, String>{
					'Content-Type': 'application/json; odata=verbos',
					'Accept': 'application/json; odata=verbos',
					'Authorization': 'Bearer ${AppData.userToken}'
				},
				body: jsonEncode(record.toJson()));

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<bool> regmv6FormHapusAPI(String regmv6Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/regmv/regmv6form/delete";
		Map<String, String> queryParams = {
			'regmv6Id': regmv6Id,
			'modul_id': 'regmv6FormHapusAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, hapusEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		ReturnDataAPI returnData;
		if (response.statusCode == 200) {
			returnData = ReturnDataAPI.fromDatabaseJson(jsonDecode(response.body));
		} else {
			returnData = ReturnDataAPI(success: false, data: "", rowcount: 0);
		}
		return returnData.success;
	}
	Future<Regmv6FormModel> regmv6FormLihatAPI(String regmv1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/regmv/regmv6form/read";
		Map<String, String> queryParams = {'regmv1Id': regmv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = Regmv6FormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
	Future<Regmv6FormModel> regmv6FormHitungPremiAPI(String regmv1Id) async {
		final hitungPremiEndpoint =
				"${AppData.prefixEndPoint}/api/regmv/regmv6form/hitungpremi";

		final queryParams = {
			'regmv1Id': regmv1Id,
			'modul_id': 'regmv6FormHitungPremi',
			'_ts': DateTime.now().millisecondsSinceEpoch.toString(), // cache buster
		};

		final uri = AppData.uriHtpp(
			AppData.httpAuthority,
			hitungPremiEndpoint,
			queryParams,
		);

		final response = await http.get(
			uri,
			headers: <String, String>{
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}',
				// ❌ jangan tambah Expires/Pragma/Cache-Control di web kalau server gak allow
			},
		);

		if (response.statusCode == 200) {
			return Regmv6FormModel.fromJson(jsonDecode(response.body));
		}
		throw Exception('Failed hitung premi: ${response.statusCode} ${response.body}');
	}


}
