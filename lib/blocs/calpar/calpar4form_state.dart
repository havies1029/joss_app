part of 'calpar4form_bloc.dart';

class Calpar4FormState extends Equatable {

	final Calpar4FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final bool isCalculating;
	final bool isCalculated;
	const Calpar4FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.isCalculating = false,
		this.isCalculated = false,
});

  static const _sentinel = Object();

	Calpar4FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		bool? isCalculating,
		bool? isCalculated,
	}){
		return Calpar4FormState(
			record: identical(record, _sentinel) ? this.record : record as Calpar4FormModel?,
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
	List<Object?> get props => [
		record,
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		isCalculating,
		isCalculated,
	];
}
