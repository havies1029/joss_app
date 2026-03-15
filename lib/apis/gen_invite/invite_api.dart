import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/gen_invite/invite_result_model.dart';

class InviteAPI {
  Future<InviteResultModel> sendInvite(
    String mrekanpicId,
    String nama,
    String email,
  ) async {
    try {

      String urlEndpoint =
			  "${AppData.prefixEndPoint}/api/undangan/menjadiuser/kirim";

		  Map<String, String> queryParams = {"mrekanpicId": mrekanpicId, "nama": nama, "email": email};
		  var uri = AppData.uriHtpp(AppData.httpAuthority, urlEndpoint, queryParams);

      final response = await http.post(
        uri,
        headers: {
				'Content-Type': 'application/json; odata=verbose',
				'Accept': 'application/json; odata=verbose',
          'Authorization': 'Bearer ${AppData.userToken}',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return InviteResultModel.fromJson(decoded);
      }

      return InviteResultModel(
        success: false,
        message: 'Gagal mengirim undangan (${response.statusCode})',
      );
    } catch (e) {
      debugPrint('Error in sendInvite: $e');
      return InviteResultModel(
        success: false,
        message: 'Terjadi kesalahan koneksi.',
      );
    }
  }
}