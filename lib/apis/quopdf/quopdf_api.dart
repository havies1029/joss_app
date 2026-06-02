import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:path_provider/path_provider.dart';

class QuotationPdfAPI {
  Future<File> downloadQuotationPdfAPI(
    String quotationType,
    String quotationNo,
  ) async {
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

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Accept': 'application/pdf',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    ).timeout(
      const Duration(seconds: 60),
    );

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'] ?? '';

      if (!contentType.toLowerCase().contains('application/pdf')) {
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

      return file;
    } else {
      throw Exception(
        "Failed to download quotation PDF. Status: ${response.statusCode}, Body: ${response.body}",
      );
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