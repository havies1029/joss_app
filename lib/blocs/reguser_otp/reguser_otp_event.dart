part of 'reguser_otp_bloc.dart';

abstract class RegUserOtpEvent extends Equatable {
  const RegUserOtpEvent();

  @override
  List<Object?> get props => [];
}

class RegUserOtpKirimEvent extends RegUserOtpEvent {
  final String target;
  final String requestFrom;

  const RegUserOtpKirimEvent({
    required this.target,
    required this.requestFrom,
  });

  @override
  List<Object?> get props => [target, requestFrom];
}

class RegUserOtpValidasiEvent extends RegUserOtpEvent {
  final String requestId;
  final String target;
  final String requestFrom;
  final String pin;

  const RegUserOtpValidasiEvent({
    required this.requestId,
    required this.target,
    required this.requestFrom,
    required this.pin,
  });

  @override
  List<Object?> get props => [requestId, target, requestFrom, pin];
}

class RegUserOtpResetEmailEvent extends RegUserOtpEvent {
  const RegUserOtpResetEmailEvent();
}

class RegUserOtpResetHpEvent extends RegUserOtpEvent {
  const RegUserOtpResetHpEvent();
}

class RegUserOtpClearEvent extends RegUserOtpEvent {
  const RegUserOtpClearEvent();
}
