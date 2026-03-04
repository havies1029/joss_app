part of 'regpar5form_bloc.dart';

class Regpar5FormState extends Equatable {

	final Regpar5FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final bool isCalculating;
	final bool isCalculated;
	const Regpar5FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.isCalculating = false,
		this.isCalculated = false,
});

	Regpar5FormState copyWith({
		Regpar5FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		bool? isCalculating,
		bool? isCalculated,
	}){
		return Regpar5FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			isCalculating: isCalculating ?? this.isCalculating,
			isCalculated: isCalculated ?? this.isCalculated,
		);
	}

	@override
	List<Object?> get props => [record, isLoading, isLoaded, isSaving, isSaved, hasFailure, isCalculating, isCalculated];
}
