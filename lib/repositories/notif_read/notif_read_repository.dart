import '../../apis/notif_read/notif_read_api.dart';

class NotifReadRepository {

  Future<bool> markNotifRead({
    required String modulId,
    required String notifType,
    required String notifId,
  }) async {
    NotifReadApi api = NotifReadApi();

    return await api.markNotifRead(
      modulId: modulId,
      notifType: notifType,
      notifId: notifId,
    );
  }

  Future<int> getNotifUnreadCount() async {
    NotifReadApi api = NotifReadApi();
    return await api.getNotifUnreadCount();
  }
}