import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:path_provider/path_provider.dart';

class QuotationPdfAPI {
  Future<File> downloadQuotationPdfAPI(
      String quotationType,
      String quotationNo,
      ) async {
    try {
      String urlEndPoint =
          "${AppData.prefixEndPoint}/api/quotation-pdf/${Uri.encodeComponent(quotationType)}";

      Map<String, String> queryParams = {
        "quotationNo": quotationNo,
      };

      var uri = AppData.uriHtpp(
        AppData.httpAuthority,
        urlEndPoint,
        queryParams,
      );

      final headers = <String, String>{
        'Accept': 'application/pdf',
        'Authorization': 'Bearer ${AppData.userToken}',
      };

      debugPrint("========== DOWNLOAD PDF REQUEST ==========");
      debugPrint("URL       : $uri");
      debugPrint("TYPE      : $quotationType");
      debugPrint("NO        : $quotationNo");
      debugPrint("HEADERS   : $headers");
      debugPrint("=========================================");

      final http.Response response = await http
          .get(
        uri,
        headers: headers,
      )
          .timeout(
        const Duration(seconds: 60),
      );

      debugPrint("========== DOWNLOAD PDF RESPONSE ==========");
      debugPrint("STATUS    : ${response.statusCode}");
      debugPrint("HEADERS   : ${response.headers}");
      debugPrint("BODY SIZE : ${response.bodyBytes.length}");

      if (response.statusCode != 200) {
        debugPrint("BODY      : ${response.body}");
      }

      debugPrint("==========================================");

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';

        debugPrint("CONTENT-TYPE : $contentType");

        if (!contentType.toLowerCase().contains('application/pdf')) {
          debugPrint("INVALID PDF RESPONSE");
          debugPrint("BODY : ${response.body}");

          throw Exception(
            "Response bukan PDF. Content-Type: $contentType",
          );
        }

        final fileName = _buildFileName(
          quotationType,
          quotationNo,
        );

        final appDocDir = await getApplicationDocumentsDirectory();

        final pdfDir = Directory("${appDocDir.path}/quotation_pdf");

        if (!await pdfDir.exists()) {
          await pdfDir.create(recursive: true);
        }

        final file = File("${pdfDir.path}/$fileName");

        await file.writeAsBytes(
          response.bodyBytes,
          flush: true,
        );

        debugPrint("========== PDF SAVED ==========");
        debugPrint("FILE NAME : $fileName");
        debugPrint("FILE PATH : ${file.path}");
        debugPrint("FILE SIZE : ${await file.length()} bytes");
        debugPrint("===============================");

        return file;
      } else {
        throw Exception(
          "Failed to download quotation PDF. "
              "Status: ${response.statusCode}, "
              "Body: ${response.body}",
        );
      }
    } catch (e, stackTrace) {
      debugPrint("========== DOWNLOAD PDF ERROR ==========");
      debugPrint("ERROR : $e");
      debugPrint("STACK : $stackTrace");
      debugPrint("========================================");

      rethrow;
    }
  }

  String _buildFileName(
    String quotationType,
    String quotationNo,
  ) {
    final safeQuotationNo = quotationNo
        .replaceAll("/", "-")
        .replaceAll("\\", "-")
        .replaceAll(":", "-");

    return "Quotation-$quotationType-$safeQuotationNo.pdf";
  }
}