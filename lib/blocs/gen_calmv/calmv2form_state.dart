part of 'calmv2form_bloc.dart';

class Calmv2FormState extends Equatable {

	final Calmv2FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ReturnDataAPI? returnData;
	final bool isComplete;
	final bool isDirty;
	final bool isValid;

	const Calmv2FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.returnData,
		this.isComplete = false,
		this.isDirty = false,
		this.isValid = false,
});

  static const _sentinel = Object();

	Calmv2FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? returnData = _sentinel,
		bool? isComplete,
		bool? isDirty,
		bool? isValid,
	}){
		return Calmv2FormState(
			record: identical(record, _sentinel) ? this.record : record as Calmv2FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			returnData: identical(returnData, _sentinel) ? this.returnData : returnData as ReturnDataAPI?,
			isComplete: isComplete ?? this.isComplete,
			isDirty: isDirty ?? this.isDirty,
			isValid: isValid ?? this.isValid,
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
		returnData,
		isComplete,
		isDirty,
		isValid,    
	];


}
