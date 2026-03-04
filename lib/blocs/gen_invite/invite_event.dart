part of 'invite_bloc.dart';

abstract class InviteEvent {}

class SendInviteEvent extends InviteEvent {
  final String userId;
  final String email;

  SendInviteEvent({required this.userId, required this.email});
}
