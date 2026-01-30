part of 'regrenew1form_bloc.dart';

class Regrenew1FormState extends Equatable {

	final Regrenew1FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	const Regrenew1FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
});

	Regrenew1FormState copyWith({
		Regrenew1FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
	}){
		return Regrenew1FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
		);
	}

	@override
	List<Object?> get props => [record, isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
