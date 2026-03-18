part of 'invite_bloc.dart';

abstract class InviteEvent {}

class SendInviteEvent extends InviteEvent {
  final String mrekanpicId;
  final String nama;
  final String email;

  SendInviteEvent({required this.mrekanpicId, required this.nama, required this.email});
}
