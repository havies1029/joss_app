import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:joss_app/models/payment/rinciansoa_model.dart';
import 'package:http/http.dart' as http;

class PaymentDnAPI{
	void _logRequest({
		required String name,
		required Uri uri,
		required Map<String, String> headers,
	}) {
		debugPrint("=== [$name] REQUEST ===");
		debugPrint("URL: $uri");
		debugPrint("Headers: $headers");
	}

	void _logResponse({
		required String name,
		required http.Response response,
	}) {
		debugPrint("=== [$name] RESPONSE ===");
		debugPrint("Status Code: ${response.statusCode}");
		debugPrint("Body: ${response.body}");
	}

	Future<List<PaymentCategory>> getPaymentMethods() async {
		String endpoint = "${AppData.prefixEndPoint}/api/payment/methods";
		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint);

		final headers = {
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		_logRequest(name: "getPaymentMethods", uri: uri, headers: headers);

		final response = await http.get(uri, headers: headers);

		_logResponse(name: "getPaymentMethods", response: response);

		if (response.statusCode == 200) {
			final List<dynamic> jsonData = json.decode(response.body);
			return jsonData.map((e) => PaymentCategory.fromJson(e)).toList();
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<InvoiceStatusModel> cekPaymentStatusAPI(String inv1Id) async {
		String endpoint = "${AppData.prefixEndPoint}/api/payment/cekstatus";

		Map<String, String> queryParams = {'inv1_id': inv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

		final headers = {
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		_logRequest(name: "cekPaymentStatusAPI", uri: uri, headers: headers);

		final response = await http.get(uri, headers: headers);

		_logResponse(name: "cekPaymentStatusAPI", response: response);

		if (response.statusCode == 200) {
			final jsonData = json.decode(response.body);
			debugPrint("Parsed status: ${jsonData['status']}");
			return InvoiceStatusModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<InvoiceStatusModel> dnToInvByListCobAPI(String listcob) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/dntoinvbylistcob";
		Map<String, String> queryParams = {'listcob': listcob, 'modulId': 'dnToInvByListCobAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(response.body) as Map<String, dynamic>;

      return InvoiceStatusModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load data");
    }
	}

	Future<InvoiceStatusModel> dnToInvByListDnAPI(String listdn) async {
		String endpoint = "${AppData.prefixEndPoint}/api/payment/dntoinvbylistdn";

		Map<String, String> queryParams = {
			'listdn': listdn,
			'modulId': 'dnToInvByListDnAPI'
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

		final headers = {
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		_logRequest(name: "dnToInvByListDnAPI", uri: uri, headers: headers);

		final response = await http.get(uri, headers: headers);

		_logResponse(name: "dnToInvByListDnAPI", response: response);

		if (response.statusCode == 200) {
			final jsonData = json.decode(response.body);
			debugPrint("Parsed status: ${jsonData['status']}");
			return InvoiceStatusModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<InvoiceStatusModel> invoice2PaymentViaVaAPI(String invoiceId, String methodId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/invtobayarviava";
		Map<String, String> queryParams = {'invoiceId': invoiceId, 'methodId': methodId, 'modulId': 'invoice2PaymentAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(response.body) as Map<String, dynamic>;

      return InvoiceStatusModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load data");
    }
	}

	Future<RincianSOAModel> getRincianSOACustomer(String searchText) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/payment/rinciansoa";

		Map<String, String> queryParams = {'searchText': searchText};
		var uri = AppData.uriHtpp(AppData.httpAuthority, urlGetListEndPoint, queryParams);
		final http.Response response = await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final Map<String, dynamic> jsonData =
			json.decode(response.body) as Map<String, dynamic>;

			return RincianSOAModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<bool> forcePaymentViaVaAPI(String invoiceId) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/forcepaymentviava";
		Map<String, String> queryParams = {'invoiceId': invoiceId};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			return true;
		} else {
			throw Exception("Failed to process data");
		}
	}

	Future<InvoiceStatusModel> regMv2InvAPI(String regmv1Id) async {
		String endpoint = "${AppData.prefixEndPoint}/api/payment/regmvtosppa";

		Map<String, String> queryParams = {
			'regmv1Id': regmv1Id,
			'modulId': 'RegMv2InvAPI'
		};

		var uri = AppData.uriHtpp(AppData.httpAuthority, endpoint, queryParams);

		final headers = {
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		};

		_logRequest(name: "regMv2InvAPI", uri: uri, headers: headers);

		final response = await http.get(uri, headers: headers);

		_logResponse(name: "regMv2InvAPI", response: response);

		if (response.statusCode == 200) {
			final jsonData = json.decode(response.body);

			debugPrint("=== PARSED ===");
			debugPrint("invoiceId: ${jsonData['invoiceId']}");
			debugPrint("status: ${jsonData['status']}");
			debugPrint("totalBayar: ${jsonData['totalBayar']}");

			return InvoiceStatusModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}

	Future<InvoiceStatusModel> regPar2InvAPI(String regpar1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/regpartosppa";
		Map<String, String> queryParams = {'regpar1Id': regpar1Id, 'modulId': 'RegPar2InvAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
		await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
			final Map<String, dynamic> jsonData =
          json.decode(response.body) as Map<String, dynamic>;

			return InvoiceStatusModel.fromJson(jsonData);
		} else {
			throw Exception("Failed to load data");
		}
	}

}
