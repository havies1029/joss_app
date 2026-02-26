part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  final ForgotPasswordModel? record;
  final bool isSending;
  final bool isSent;
  final bool hasFailure;
  final bool verificationEmailSuccess;
  final bool verificationPinSuccess;
  final bool resetPasswordSuccess;

  const ForgotPasswordState({
    this.record,
    this.isSending = false,
    this.isSent = false,
    this.hasFailure = false,
    this.verificationEmailSuccess = false,
    this.verificationPinSuccess = false,
    this.resetPasswordSuccess = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordModel? record,
    bool? isSending,
    bool? isSent,
    bool? hasFailure,
    bool? verificationEmailSuccess,
    bool? verificationPinSuccess,
    bool? resetPasswordSuccess,
  }) {
    return ForgotPasswordState(
      record: record ?? this.record,
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      hasFailure: hasFailure ?? this.hasFailure,
      verificationEmailSuccess: verificationEmailSuccess ?? this.verificationEmailSuccess,
      verificationPinSuccess: verificationPinSuccess ?? this.verificationPinSuccess,
      resetPasswordSuccess: resetPasswordSuccess ?? this.resetPasswordSuccess,
    );
  }

  @override
  List<Object?> get props => [
    isSending,
    isSent,
    hasFailure,
    verificationEmailSuccess,
    verificationPinSuccess,
    resetPasswordSuccess,
    record,
  ];
}
