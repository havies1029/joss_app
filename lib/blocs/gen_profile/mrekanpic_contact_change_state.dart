part of 'mrekanpic_contact_change_bloc.dart';

enum MRekanPicContactChangePhase {
  initial,
  sending,
  otpSent,
  validating,
  verified,
  preparing,
  prepared,
  expired,
  failure,
}

class MRekanPicContactChangeState extends Equatable {
  final MRekanPicContactChangePhase phase;
  final String changeRequestId;
  final int? backendStatusId;
  final int? changeTypeId;
  final int? verifyViaId;
  final String maskedTarget;
  final DateTime? otpExpiresAt;
  final DateTime? authorizationExpiresAt;
  final int? remainingAttempts;
  final String message;
  final bool hasFailure;
  final MRekanPicContactChangeResult? result;

  const MRekanPicContactChangeState({
    this.phase = MRekanPicContactChangePhase.initial,
    this.changeRequestId = '',
    this.backendStatusId,
    this.changeTypeId,
    this.verifyViaId,
    this.maskedTarget = '',
    this.otpExpiresAt,
    this.authorizationExpiresAt,
    this.remainingAttempts,
    this.message = '',
    this.hasFailure = false,
    this.result,
  });

  bool get isLoading =>
      phase == MRekanPicContactChangePhase.sending ||
      phase == MRekanPicContactChangePhase.validating ||
      phase == MRekanPicContactChangePhase.preparing;

  bool get isOtpSent => phase == MRekanPicContactChangePhase.otpSent;
  bool get isVerified => phase == MRekanPicContactChangePhase.verified;
  bool get isPrepared => phase == MRekanPicContactChangePhase.prepared;

  static const _unset = Object();

  MRekanPicContactChangeState copyWith({
    MRekanPicContactChangePhase? phase,
    String? changeRequestId,
    Object? backendStatusId = _unset,
    Object? changeTypeId = _unset,
    Object? verifyViaId = _unset,
    String? maskedTarget,
    Object? otpExpiresAt = _unset,
    Object? authorizationExpiresAt = _unset,
    Object? remainingAttempts = _unset,
    String? message,
    bool? hasFailure,
    Object? result = _unset,
  }) {
    return MRekanPicContactChangeState(
      phase: phase ?? this.phase,
      changeRequestId: changeRequestId ?? this.changeRequestId,
      backendStatusId: identical(backendStatusId, _unset)
          ? this.backendStatusId
          : backendStatusId as int?,
      changeTypeId: identical(changeTypeId, _unset)
          ? this.changeTypeId
          : changeTypeId as int?,
      verifyViaId: identical(verifyViaId, _unset)
          ? this.verifyViaId
          : verifyViaId as int?,
      maskedTarget: maskedTarget ?? this.maskedTarget,
      otpExpiresAt: identical(otpExpiresAt, _unset)
          ? this.otpExpiresAt
          : otpExpiresAt as DateTime?,
      authorizationExpiresAt: identical(authorizationExpiresAt, _unset)
          ? this.authorizationExpiresAt
          : authorizationExpiresAt as DateTime?,
      remainingAttempts: identical(remainingAttempts, _unset)
          ? this.remainingAttempts
          : remainingAttempts as int?,
      message: message ?? this.message,
      hasFailure: hasFailure ?? false,
      result: identical(result, _unset)
          ? this.result
          : result as MRekanPicContactChangeResult?,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        changeRequestId,
        backendStatusId,
        changeTypeId,
        verifyViaId,
        maskedTarget,
        otpExpiresAt,
        authorizationExpiresAt,
        remainingAttempts,
        message,
        hasFailure,
        result,
      ];
}
