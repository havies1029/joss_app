part of 'notif_email_setting_bloc.dart';

abstract class NotifEmailSettingEvent extends Equatable {
  const NotifEmailSettingEvent();

  @override
  List<Object?> get props => [];
}

class NotifEmailSettingLihatEvent extends NotifEmailSettingEvent {}

class NotifEmailSettingUbahEvent extends NotifEmailSettingEvent {
  final bool isNotifEmail;

  const NotifEmailSettingUbahEvent(this.isNotifEmail);

  @override
  List<Object?> get props => [isNotifEmail];
}
