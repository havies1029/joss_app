import 'dart:io';

import 'package:joss_app/apis/quopdf/quopdf_api.dart';

class QuotationPdfRepository {
  Future<File> downloadQuotationPdf(
      String quotationType,
      String quotationNo,
      ) async {
    return await QuotationPdfAPI().downloadQuotationPdfAPI(
      quotationType,
      quotationNo,
    );
  }
}