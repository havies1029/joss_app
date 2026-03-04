// lib/apis/gen_invite/invite_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/gen_invite/invite_model.dart';

class InviteAPI {
  Future<InviteModel> sendInvite(String userId, String email) async {
    final uri = Uri.parse(
      'https://eassisttoolsapi.smartsoft-id.com/api/undangan/menjadiuser/kirim'
          '?userId=$userId&email=${Uri.encodeComponent(email)}',
    );

    print('🌐 [InviteAPI] Request: $uri');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    );

    print('📡 [InviteAPI] Status: ${response.statusCode}');
    print('📦 [InviteAPI] Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return InviteModel.fromJson({
        'userId': userId,
        'email': email,
        'success': decoded['success'] ?? true,
        'message': decoded['message'] ?? 'Undangan berhasil dikirim',
      });
    } else {
      return InviteModel(
        userId: userId,
        email: email,
        success: false,
        message: 'Gagal mengirim undangan (${response.statusCode})',
      );
    }
  }
}
