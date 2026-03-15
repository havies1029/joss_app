// lib/repositories/gen_invite/invite_repository.dart
import 'package:joss_app/apis/gen_invite/invite_api.dart';
import 'package:joss_app/models/gen_invite/invite_result_model.dart';

class InviteRepository {
  final InviteAPI _api = InviteAPI();

  Future<InviteResultModel> sendInvite(String mrekanpicId, String nama, String email) async {
    try {
      final result = await _api.sendInvite(mrekanpicId, nama, email);
      return result;
    } catch (e) {      
      return InviteResultModel(
        success: false,
        message: e.toString(),
      );
    }
  }
}
