part of 'forgot_password_reset_bloc.dart';

abstract class ForgotPasswordResetEvent extends Equatable {
  const ForgotPasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordResetSendOtpEvent extends ForgotPasswordResetEvent {
  final ForgotPasswordOtpSendModel record;

  const ForgotPasswordResetSendOtpEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class ForgotPasswordResetValidateOtpEvent extends ForgotPasswordResetEvent {
  final ForgotPasswordOtpValidateModel record;

  const ForgotPasswordResetValidateOtpEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class ForgotPasswordResetSubmitEvent extends ForgotPasswordResetEvent {
  final ForgotPasswordResetModel record;

  const ForgotPasswordResetSubmitEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class ForgotPasswordResetClearMessageEvent extends ForgotPasswordResetEvent {
  const ForgotPasswordResetClearMessageEvent();
}

class ForgotPasswordResetFlagsEvent extends ForgotPasswordResetEvent {
  const ForgotPasswordResetFlagsEvent();
}
