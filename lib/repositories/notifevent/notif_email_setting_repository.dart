import 'package:joss_app/apis/notifevent/notif_email_setting_api.dart';
import 'package:joss_app/models/notifevent/notif_email_setting_model.dart';

class NotifEmailSettingRepository {
  Future<NotifEmailSettingModel> read() {
    return NotifEmailSettingApi().read();
  }

  Future<bool> update(bool isNotifEmail) {
    return NotifEmailSettingApi().update(isNotifEmail);
  }
}
