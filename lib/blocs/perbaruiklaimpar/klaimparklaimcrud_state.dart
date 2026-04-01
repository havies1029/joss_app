part of 'klaimparklaimcrud_bloc.dart';

class KlaimparklaimcrudState extends Equatable {
	final KlaimparklaimcrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMJenisrugiModel? comboMJenisrugi;
	final bool isDirty;
	final bool isComplete;
	final bool isValid;

	const KlaimparklaimcrudState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMJenisrugi,
		this.isDirty = false,
		this.isComplete = false,
		this.isValid = false,
	});

	KlaimparklaimcrudState copyWith({
		KlaimparklaimcrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMJenisrugiModel? comboMJenisrugi,
		bool? isDirty,
		bool? isComplete,
		bool? isValid,
	}) {
		return KlaimparklaimcrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMJenisrugi: comboMJenisrugi ?? this.comboMJenisrugi,
			isDirty: isDirty ?? this.isDirty,
			isComplete: isComplete ?? this.isComplete,
			isValid: isValid ?? this.isValid,
		);
	}

	@override
	List<Object> get props => [
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		record ?? '',
		comboMJenisrugi ?? '',
		isDirty,
		isComplete,
		isValid,
	];
}