part of 'emailverification_bloc.dart';

class EmailVerificationState extends Equatable {
  final EmailVerificationModel? record;
  final bool isLoading;
  final bool isLoaded;
  final bool isSaving;
  final bool isSaved;
  final bool hasFailure;
  final String token;
  final bool verificationFailed;
  final List<String> errors;
  final bool isSimpanPassword;
  final String email;
  final String telepon;

  const EmailVerificationState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.token = '',
    this.verificationFailed = false,
    this.errors = const [],
    this.isSimpanPassword = true,
    this.email = '',
    this.telepon = '',
  });

  EmailVerificationState copyWith({
    EmailVerificationModel? record,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    bool? requestPinVerification,
    String? token,
    bool? verificationFailed,
    List<String>? errors,
    bool? isSimpanPassword,
    String? email,
    String? telepon,
  }) {
    return EmailVerificationState(
      record: record ?? this.record,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      token: token ?? this.token,
      verificationFailed: verificationFailed ?? this.verificationFailed,
      errors: errors ?? this.errors,
      isSimpanPassword: isSimpanPassword ?? this.isSimpanPassword,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoaded,
    isSaving,
    isSaved,
    hasFailure,
    token,
    verificationFailed,
    errors,
    isSimpanPassword,
    record,
    email,
    telepon,
  ];
}
