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
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure,
    verificationFailed, requestFrom, errors];
}
