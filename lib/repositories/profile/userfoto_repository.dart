// repositories/image_repository.dart
import 'dart:typed_data';

import 'package:joss_app/apis/profile/userfoto_api.dart';

class UserFotoRepository {
  Future<Uint8List?> getUserProfileFotoImageBytes() {
    UserFotoApi api = UserFotoApi();
    return api.getUserProfileFotoImageBytes();
  }
}
