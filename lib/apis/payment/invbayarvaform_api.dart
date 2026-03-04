import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/models/payment/invbayarvaform_model.dart';

class InvbayarvaFormAPI {

	
	Future<InvbayarvaFormModel> invbayarvaFormLihatAPI(String invoiceId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/invbayarvaform/read";
		Map<String, String> queryParams = {'invoiceId': invoiceId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			var returnData = InvbayarvaFormModel.fromJson(jsonDecode(response.body));
			return returnData;
		} else {
			return throw Exception("Failed to load data");
		}
	}
}
