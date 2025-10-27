// lib/repositories/gen_invite/invite_repository.dart
import 'package:joss_app/apis/gen_invite/invite_api.dart';
import 'package:joss_app/models/gen_invite/invite_model.dart';

class InviteRepository {
  final InviteAPI _api = InviteAPI();

  Future<InviteModel> sendInvite(String userId, String email) async {
    try {
      print('📤 [InviteRepository] Sending invite for $email...');
      final result = await _api.sendInvite(userId, email);
      print('✅ [InviteRepository] ${result.message}');
      return result;
    } catch (e) {
      print('💥 [InviteRepository] Error: $e');
      return InviteModel(
        userId: userId,
        email: email,
        success: false,
        message: e.toString(),
      );
    }
  }
}
