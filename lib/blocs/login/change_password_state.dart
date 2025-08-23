part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
  const ChangePasswordState({
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false
  });

  ChangePasswordState copyWith({
    bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
  }){
    return ChangePasswordState(
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
    );
  }

  @override
  List<Object> get props => [isSaving, isSaved, hasFailure];
}
