import 'dart:convert';
import 'package:joss_app/apis/payment/invoice_download_api.dart';

class InvoiceDownloadRepository {
  final InvoiceDownloadApi api = InvoiceDownloadApi();

  Future<String> downloadInvoice(String noInv) async {
    final response = await api.downloadInvoice(noInv);
    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    // BODY STRING : [{"response_code":"200",...,"inv":"JVBERi0x..."}]
    final decoded = jsonDecode(response.body);

    if (decoded is! List || decoded.isEmpty) {
      throw Exception("Format response tidak valid (bukan list / kosong)");
    }

    final obj = Map<String, dynamic>.from(decoded.first);

    if (obj['response_code']?.toString() != '200') {
      throw Exception(obj['response_message']?.toString() ?? 'Gagal');
    }

    final inv = (obj['inv'] ?? '').toString();
    if (inv.isEmpty) throw Exception("Field inv kosong");

    // return base64 string
    return inv;
  }
}