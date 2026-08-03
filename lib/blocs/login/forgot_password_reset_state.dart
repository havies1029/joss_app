part of 'forgot_password_reset_bloc.dart';

class ForgotPasswordResetState extends Equatable {
  final String requestId;
  final String target;
  final String requestFrom;
  final bool isSending;
  final bool isValidating;
  final bool isResetting;
  final bool sendOtpSuccess;
  final bool validateOtpSuccess;
  final bool validateOtpFailed;
  final bool resetPasswordSuccess;
  final String errorMessage;

  const ForgotPasswordResetState({
    this.requestId = '',
    this.target = '',
    this.requestFrom = 'email',
    this.isSending = false,
    this.isValidating = false,
    this.isResetting = false,
    this.sendOtpSuccess = false,
    this.validateOtpSuccess = false,
    this.validateOtpFailed = false,
    this.resetPasswordSuccess = false,
    this.errorMessage = '',
  });

  ForgotPasswordResetState copyWith({
    String? requestId,
    String? target,
    String? requestFrom,
    bool? isSending,
    bool? isValidating,
    bool? isResetting,
    bool? sendOtpSuccess,
    bool? validateOtpSuccess,
    bool? validateOtpFailed,
    bool? resetPasswordSuccess,
    String? errorMessage,
  }) {
    return ForgotPasswordResetState(
      requestId: requestId ?? this.requestId,
      target: target ?? this.target,
      requestFrom: requestFrom ?? this.requestFrom,
      isSending: isSending ?? this.isSending,
      isValidating: isValidating ?? this.isValidating,
      isResetting: isResetting ?? this.isResetting,
      sendOtpSuccess: sendOtpSuccess ?? this.sendOtpSuccess,
      validateOtpSuccess: validateOtpSuccess ?? this.validateOtpSuccess,
      validateOtpFailed: validateOtpFailed ?? this.validateOtpFailed,
      resetPasswordSuccess:
          resetPasswordSuccess ?? this.resetPasswordSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  ForgotPasswordResetState resetActionFlags() {
    return copyWith(
      sendOtpSuccess: false,
      validateOtpSuccess: false,
      validateOtpFailed: false,
      resetPasswordSuccess: false,
      errorMessage: '',
    );
  }

  @override
  List<Object?> get props => [
        requestId,
        target,
        requestFrom,
        isSending,
        isValidating,
        isResetting,
        sendOtpSuccess,
        validateOtpSuccess,
        validateOtpFailed,
        resetPasswordSuccess,
        errorMessage,
      ];
}
