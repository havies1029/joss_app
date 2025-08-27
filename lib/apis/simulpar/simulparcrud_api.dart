import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/simulpar/calcpremipar_model.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/simulpar/simulparcrud_model.dart';

class SimulparCrudAPI {

	Future<ReturnDataAPI> simulparCrudTambahAPI(SimulparCrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/simulpar/simulparcrud/create";
		Map<String, String> queryParams = {"modul_id": "simulparCrudTambahAPI"};
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

	Future<bool> simulparCrudUbahAPI(SimulparCrudModel record) async {
		String ubahEndpoint =
			"${AppData.prefixEndPoint}/api/simulpar/simulparcrud/update";
		Map<String, String> queryParams = {"modul_id": "simulparCrudUbahAPI"};

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
	Future<bool> simulparCrudHapusAPI(String simulpar1Id) async {
		String hapusEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/delete";
		Map<String, String> queryParams = {
			'simulpar1Id': simulpar1Id,
			'modul_id': 'simulparCrudHapusAPI'};
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
	Future<SimulparCrudModel> simulparCrudLihatAPI(String simulpar1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/read";
		Map<String, String> queryParams = {'simulpar1Id': simulpar1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = SimulparCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<SimulparCrudModel> simulParCrudInitValueAPI() async {
		String initValueEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/initvalue";		
		var uri = AppData.uriHtpp(AppData.httpAuthority, initValueEndpoint);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = SimulparCrudModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<double> simulParCrudGetRateFlexasAPI(String okupasiId, String konstruksiId) async {
		String initValueEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/getrateflexas";		
		Map<String, String> queryParams = {'okupasiId': okupasiId, 'konstruksiId': konstruksiId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, initValueEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var rateFlexas = jsonDecode(response.body);
			return rateFlexas;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<double> simulParCrudGetRateTsfwdAPI(String wilayahId) async {
		String initValueEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/getratetsfwd";		
		Map<String, String> queryParams = {'wilayahId': wilayahId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, initValueEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var rate = jsonDecode(response.body);
			return rate;
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<double> simulParCrudGetRateEqvetPI(String kabupatenId, String okupasiId) async {
		String initValueEndpoint = "${AppData.prefixEndPoint}/api/simulpar/simulparcrud/getrateeqvet";		
		Map<String, String> queryParams = {'kabupatenId': kabupatenId, 'okupasiId': okupasiId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, initValueEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var rate = jsonDecode(response.body);
			return rate;
		} else {
			return throw Exception("Failed to load data");
		}
	}

	Future<CalcpremiparModel> simulParCalPremiAPI(SimulparCrudModel record) async {
		String urlEndpoint =
			"${AppData.prefixEndPoint}/api/simulpar/simulparcrud/calcpremipar";
		Map<String, String> queryParams = {"modul_id": "simulParCalPremiAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlEndpoint, queryParams);

		CalcpremiparModel returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
			body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = CalcpremiparModel.fromJson(jsonDecode(response.body));
		} else {
			returnData = CalcpremiparModel(issuccess: false, errordesc: "");
		}
		return returnData;
	}

}
