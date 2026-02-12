import 'package:http/http.dart' as http;

class InvoiceDownloadApi {

  Future<http.Response> downloadInvoice(String noInv) async {
    final uri = Uri.https(
      'jossadminapi.smartsoft-id.com',
      '/api/inv/download',
      {'no_inv': noInv},
    );

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer MjAyNTEySk9TUzAxOlhQb29mSDZneXZ1QU1LK2NDN01kWUE9PQ==",
      },
    );

    return response;
  }
}