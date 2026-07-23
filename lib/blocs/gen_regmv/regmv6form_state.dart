part of 'regmv6form_bloc.dart';

class Regmv6FormState extends Equatable {

	final Regmv6FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final bool isCalculating;
	final bool isCalculated;
	final String recordOwnerId;

	const Regmv6FormState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.isCalculating = false,
				this.isCalculated = false,
				this.recordOwnerId = '',
			});

	Regmv6FormState copyWith({
		Regmv6FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		bool? isCalculating,
		bool? isCalculated,
		String? recordOwnerId,
	}){
		return Regmv6FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			isCalculating: isCalculating ?? this.isCalculating,
			isCalculated: isCalculated ?? this.isCalculated,
			recordOwnerId: recordOwnerId ?? this.recordOwnerId,
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
		recordOwnerId,
	];

}
