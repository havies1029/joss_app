import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/payment/dnheadercob_model.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:http/http.dart' as http;

class PaymentDnAPI{
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

  Future<List<InvoiceStatusModel>> cekPaymentStatusAPI(String inv1Id) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/cekstatus";
		Map<String, String> queryParams = {'inv1_id': inv1Id};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => InvoiceStatusModel.fromJson(e))
          .toList();
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<List<InvoiceStatusModel>> dnToInvByListCobAPI(String listcob) async {
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
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => InvoiceStatusModel.fromJson(e))
          .toList();
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<List<InvoiceStatusModel>> dnToInvByListDnAPI(String listdn) async {
		String lihatEndpoint = "${AppData.prefixEndPoint}/api/payment/dntoinvbylistdn";
		Map<String, String> queryParams = {'listdn': listdn, 'modulId': 'dnToInvByListDnAPI'};
		var uri = AppData.uriHtpp(AppData.httpAuthority, lihatEndpoint, queryParams);
		final http.Response response =
			await http.get(uri, headers: <String, String>{
			'Content-Type': 'application/json; odata=verbos',
			'Accept': 'application/json; odata=verbos',
			'Authorization': 'Bearer ${AppData.userToken}'
		});

		if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => InvoiceStatusModel.fromJson(e))
          .toList();
		} else {
			return throw Exception("Failed to load data");
		}
	}

  Future<List<InvoiceStatusModel>> invoice2PaymentViaVaAPI(String invoiceId, String methodId) async {
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
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData
          .map((e) => InvoiceStatusModel.fromJson(e))
          .toList();
		} else {
			return throw Exception("Failed to load data");
		}
	}

	Future<List<DnHeaderCobModel>> getRincianSOACustomer(String searchText) async {
		String urlGetListEndPoint = "${AppData.prefixEndPoint}/api/payment/rinciansoa";

		Map<String, String> queryParams = {'searchText': searchText};

		var uri = AppData.uriHtpp(
			AppData.httpAuthority,
			urlGetListEndPoint,
			queryParams,
		);

		debugPrint("🔎 GET RINCIAN SOA");
		debugPrint("➡️ URI        : $uri");
		debugPrint("➡️ Query      : $queryParams");
		debugPrint("➡️ Token null?: ${AppData.userToken == null}");

		final http.Response response = await http.get(
			uri,
			headers: <String, String>{
				'Content-Type': 'application/json',
				'Accept': 'application/json',
				'Authorization': 'Bearer ${AppData.userToken}',
			},
		);

		debugPrint("📡 STATUS     : ${response.statusCode}");
		debugPrint("📩 RAW BODY   : ${response.body.length > 300 ? response.body.substring(0, 300) + '...' : response.body}");

		if (response.statusCode == 200) {
			final List<dynamic> jsonData = json.decode(response.body);

			debugPrint("📦 DATA COUNT : ${jsonData.length}");

			return jsonData
					.map((e) => DnHeaderCobModel.fromJson(e))
					.toList();
		} else {
			debugPrint("❌ FAILED LOAD — ${response.statusCode}");
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
			return throw Exception("Failed to process data");
		}
	}

}
