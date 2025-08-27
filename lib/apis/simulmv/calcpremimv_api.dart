import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/simulmv/simulmvcrud_model.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/simulmv/calcpremimv_model.dart';

class CalcPremiMvAPI{

  Future<CalcPremiMvModel> calcPremiMVAPI(SimulmvCrudModel record) async {
		String tambahEndpoint =
			"${AppData.prefixEndPoint}/api/simulmv/simulmvcrud/calcpremi";
		Map<String, String> queryParams = {"modul_id": "CalcPremiMVAPI"};
		var uri = AppData.uriHtpp(AppData.httpAuthority, tambahEndpoint, queryParams);

		CalcPremiMvModel returnData;
		final http.Response response = await http.post(uri,
			headers: <String, String>{
				'Content-Type': 'application/json; odata=verbos',
				'Accept': 'application/json; odata=verbos',
				'Authorization': 'Bearer ${AppData.userToken}'
			},
			body: jsonEncode(record.toJson()));

		if (response.statusCode == 200) {
			returnData = CalcPremiMvModel.fromJson(jsonDecode(response.body));
		} else {
			returnData = CalcPremiMvModel(premiCasco: 0, premiExtCover: 0, premiTotal: 0);
		}
		return returnData;
	}


}
