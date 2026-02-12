import 'dart:io';

import 'package:joss_app/apis/payment/invoice_download_api.dart';
import 'package:path_provider/path_provider.dart';

class InvoiceDownloadRepository {
  InvoiceDownloadApi api = InvoiceDownloadApi();

  Future<String> downloadInvoice(String noInv) async {
    final response = await api.downloadInvoice(noInv);
    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/INVOICE_$noInv.jpg";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}