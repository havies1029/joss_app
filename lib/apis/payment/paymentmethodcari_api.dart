import 'dart:convert';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:http/http.dart' as http;

class PaymentMethodCariAPI{
	Future<List<PaymentCategory>> getPaymentMethods() async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/payment/methods";
    
    var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => PaymentCategory.fromJson(e))
          .toList();
		} else {
			throw Exception("Failed to load data");
		}
	}
}
