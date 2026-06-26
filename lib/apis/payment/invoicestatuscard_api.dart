import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/payment/invoicestatuscard_model.dart';

class InvoiceStatusCardAPI {
  Future<InvoiceStatusCards> invToBayarViaCardAPI({
    required String invoiceId,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvn,
    required String cardholderFirstName,
    required String cardholderLastName,
  }) async {
    try {
      String endpoint =
          "${AppData.prefixEndPoint}/api/payment/invtobayarviacard";

      Map<String, String> queryParams = {
        'invoiceId': invoiceId,
        'card_number': cardNumber,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'cvn': cvn,
        'cardholder_first_name': cardholderFirstName,
        'cardholder_last_name': cardholderLastName,
        'modulId': 'invToBayarViaCardAPI',
      };

      var uri = AppData.uriHtpp(
        AppData.httpAuthority,
        endpoint,
        queryParams,
      );

      debugPrint(
          "========== invToBayarViaCardAPI REQUEST ==========");
      debugPrint("URL : $uri");
      debugPrint("QUERY PARAMS : $queryParams");

      final http.Response response =
      await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json; odata=verbos',
        'Accept': 'application/json; odata=verbos',
        'Authorization': 'Bearer ${AppData.userToken}',
      });

      debugPrint(
          "========== invToBayarViaCardAPI RESPONSE ==========");
      debugPrint("STATUS CODE : ${response.statusCode}");
      debugPrint("BODY : ${response.body}");

      if (response.statusCode == 200) {
        final decoded = response.body.trim().isEmpty
            ? null
            : jsonDecode(response.body);

        final result = decoded is Map<String, dynamic>
            ? InvoiceStatusCards.fromJson(decoded)
            : InvoiceStatusCards.empty();

        debugPrint(
            "========== invToBayarViaCardAPI PARSED ==========");
        debugPrint("invoiceId : ${result.invoiceId}");
        debugPrint("status : ${result.status}");
        debugPrint("totalBayar : ${result.totalBayar}");
        debugPrint("curr : ${result.curr}");
        debugPrint("redirectUrl : ${result.redirectUrl}");

        return result;
      } else {
        debugPrint(
            "========== invToBayarViaCardAPI ERROR RESPONSE ==========");
        debugPrint("STATUS CODE : ${response.statusCode}");
        debugPrint("BODY : ${response.body}");

        throw Exception(
          "Failed to load data. StatusCode=${response.statusCode}",
        );
      }
    } catch (e, s) {
      debugPrint(
          "========== invToBayarViaCardAPI EXCEPTION ==========");
      debugPrint("ERROR : $e");
      debugPrint("STACKTRACE : $s");

      rethrow;
    }
  }
}