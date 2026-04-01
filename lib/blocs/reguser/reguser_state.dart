part of 'reguser_bloc.dart';

class RegUserState extends Equatable {

	final RegUserModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
  final bool verificationFailed;  
  final String requestFrom;
	final List<String> errors;
	final bool isEmail;
  final bool isResendOtp;
	final String sentTo;
	final String sentVia;
	final bool isOtpClient;

	const RegUserState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
    this.verificationFailed = false,
    this.requestFrom = "",
    this.errors = const [],
		this.isEmail = false,
    this.isResendOtp = false,
		this.sentTo = '',
		this.sentVia = '',
		this.isOtpClient = false,
});

	RegUserState copyWith({
		RegUserModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
    bool? verificationFailed,
    String? requestFrom,
    List<String>? errors,
		bool? isEmail,
    bool? isResendOtp,
		String? sentTo,
		String? sentVia,
		bool? isOtpClient,
	}){
		return RegUserState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
      verificationFailed: verificationFailed ?? this.verificationFailed,
      requestFrom: requestFrom ?? this.requestFrom,
      errors: errors ?? this.errors,
			isEmail: isEmail ?? this.isEmail,
      isResendOtp: isResendOtp ?? this.isResendOtp,
			sentTo: sentTo ?? this.sentTo,
			sentVia: sentVia ?? this.sentVia,
			isOtpClient: isOtpClient ?? this.isOtpClient,
		);
	}

	@override
	List<Object> get props => [isEmail, isLoading, isLoaded, isSaving, isSaved, hasFailure,
    verificationFailed, requestFrom, errors, isResendOtp, sentTo, sentVia, isOtpClient,];
}
