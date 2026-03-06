part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  final RequestOtpModel? record;

  final bool isLoading;

  final bool requestOtpSuccess;
  final bool resendOtpSuccess;
  final bool verificationPinSuccess;
  final bool verificationPinFailed;
  final bool resetPasswordSuccess;

  final String errorMessage;

  const ForgotPasswordState({
    this.record,
    this.isLoading = false,
    this.requestOtpSuccess = false,
    this.resendOtpSuccess = false,
    this.verificationPinSuccess = false,
    this.verificationPinFailed = false,
    this.resetPasswordSuccess = false,
    this.errorMessage = "",
  });

  ForgotPasswordState copyWith({
    RequestOtpModel? record,
    bool clearRecord = false,
    bool? isLoading,
    bool? requestOtpSuccess,
    bool? resendOtpSuccess,
    bool? verificationPinSuccess,
    bool? verificationPinFailed,
    bool? resetPasswordSuccess,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      record: clearRecord ? null : (record ?? this.record),
      isLoading: isLoading ?? this.isLoading,
      requestOtpSuccess: requestOtpSuccess ?? this.requestOtpSuccess,
      resendOtpSuccess: resendOtpSuccess ?? this.resendOtpSuccess,
      verificationPinSuccess:
          verificationPinSuccess ?? this.verificationPinSuccess,
      verificationPinFailed:
          verificationPinFailed ?? this.verificationPinFailed,
      resetPasswordSuccess:
          resetPasswordSuccess ?? this.resetPasswordSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  ForgotPasswordState resetActionFlags() {
    return copyWith(
      requestOtpSuccess: false,
      resendOtpSuccess: false,
      verificationPinSuccess: false,
      verificationPinFailed: false,
      resetPasswordSuccess: false,
      errorMessage: "",
    );
  }

  @override
  List<Object?> get props => [
        record,
        isLoading,
        requestOtpSuccess,
        resendOtpSuccess,
        verificationPinSuccess,
        verificationPinFailed,
        resetPasswordSuccess,
        errorMessage,
      ];
}