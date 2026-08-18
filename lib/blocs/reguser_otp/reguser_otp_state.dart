part of 'reguser_otp_bloc.dart';

class RegUserHpRegistrationStatus {
  static const registered = 'REGISTERED';
  static const registeredLogin = 'REGISTERED_LOGIN';
  static const registeredPic = 'REGISTERED_PIC';
  static const notRegistered = 'NOT_REGISTERED';

  static bool isRegisteredStatus(String value) {
    return value == registered || value == registeredPic;
  }
}

class RegUserOtpVerifiedTarget extends Equatable {
  final String requestFrom;
  final String target;
  final String requestId;

  const RegUserOtpVerifiedTarget({
    required this.requestFrom,
    required this.target,
    required this.requestId,
  });

  @override
  List<Object?> get props => [requestFrom, target, requestId];
}

class RegUserOtpState extends Equatable {
  final String emailRequestId;
  final String hpRequestId;
  final bool isEmailSending;
  final bool isHpSending;
  final bool isEmailValidating;
  final bool isHpValidating;
  final bool isHpStatusChecking;
  final bool isEmailVerified;
  final bool isHpVerified;
  final String emailError;
  final String hpError;
  final String hpRegistrationStatus;
  final String hpStatusRequestId;
  final String hpStatusTarget;
  final String activeTarget;
  final String activeRequestFrom;
  final String message;
  final bool hasFailure;
  final List<RegUserOtpVerifiedTarget>? verifiedTargets;

  const RegUserOtpState({
    this.emailRequestId = '',
    this.hpRequestId = '',
    this.isEmailSending = false,
    this.isHpSending = false,
    this.isEmailValidating = false,
    this.isHpValidating = false,
    this.isHpStatusChecking = false,
    this.isEmailVerified = false,
    this.isHpVerified = false,
    this.emailError = '',
    this.hpError = '',
    this.hpRegistrationStatus = '',
    this.hpStatusRequestId = '',
    this.hpStatusTarget = '',
    this.activeTarget = '',
    this.activeRequestFrom = '',
    this.message = '',
    this.hasFailure = false,
    this.verifiedTargets = const [],
  });

  RegUserOtpState copyWith({
    String? emailRequestId,
    String? hpRequestId,
    bool? isEmailSending,
    bool? isHpSending,
    bool? isEmailValidating,
    bool? isHpValidating,
    bool? isHpStatusChecking,
    bool? isEmailVerified,
    bool? isHpVerified,
    String? emailError,
    String? hpError,
    String? hpRegistrationStatus,
    String? hpStatusRequestId,
    String? hpStatusTarget,
    String? activeTarget,
    String? activeRequestFrom,
    String? message,
    bool? hasFailure,
    List<RegUserOtpVerifiedTarget>? verifiedTargets,
  }) {
    return RegUserOtpState(
      emailRequestId: emailRequestId ?? this.emailRequestId,
      hpRequestId: hpRequestId ?? this.hpRequestId,
      isEmailSending: isEmailSending ?? this.isEmailSending,
      isHpSending: isHpSending ?? this.isHpSending,
      isEmailValidating: isEmailValidating ?? this.isEmailValidating,
      isHpValidating: isHpValidating ?? this.isHpValidating,
      isHpStatusChecking: isHpStatusChecking ?? this.isHpStatusChecking,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isHpVerified: isHpVerified ?? this.isHpVerified,
      emailError: emailError ?? this.emailError,
      hpError: hpError ?? this.hpError,
      hpRegistrationStatus: hpRegistrationStatus ?? this.hpRegistrationStatus,
      hpStatusRequestId: hpStatusRequestId ?? this.hpStatusRequestId,
      hpStatusTarget: hpStatusTarget ?? this.hpStatusTarget,
      activeTarget: activeTarget ?? this.activeTarget,
      activeRequestFrom: activeRequestFrom ?? this.activeRequestFrom,
      message: message ?? this.message,
      hasFailure: hasFailure ?? this.hasFailure,
      verifiedTargets: verifiedTargets ?? this.verifiedTargets ?? const [],
    );
  }

  @override
  List<Object?> get props => [
        emailRequestId,
        hpRequestId,
        isEmailSending,
        isHpSending,
        isEmailValidating,
        isHpValidating,
        isHpStatusChecking,
        isEmailVerified,
        isHpVerified,
        emailError,
        hpError,
        hpRegistrationStatus,
        hpStatusRequestId,
        hpStatusTarget,
        activeTarget,
        activeRequestFrom,
        message,
        hasFailure,
        verifiedTargets ?? const [],
      ];
}
