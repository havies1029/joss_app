part of 'notif_read_bloc.dart';

abstract class NotifReadEvents extends Equatable {
  const NotifReadEvents();

  @override
  List<Object> get props => [];
}

class MarkNotifReadEvent extends NotifReadEvents {
  final String modulId;
  final String notifType;
  final String notifId;

  const MarkNotifReadEvent({
    required this.modulId,
    required this.notifType,
    required this.notifId,
  });

  @override
  List<Object> get props => [modulId, notifType, notifId];
}

class FetchNotifUnreadCountEvent extends NotifReadEvents {}

class RefreshNotifUnreadCountEvent extends NotifReadEvents {}

