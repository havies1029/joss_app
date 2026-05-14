part of 'klaimparklaimcrud_bloc.dart';

class KlaimparklaimcrudState extends Equatable {
	final KlaimparklaimcrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMJenisrugiModel? comboMJenisrugi;
	final ComboRMatauangModel? comboRMatauang;
	final bool isDirty;
	final bool isComplete;

	const KlaimparklaimcrudState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMJenisrugi,
		this.comboRMatauang,
		this.isDirty = false,
		this.isComplete = false,
	});

	static const _sentinel = Object();

	KlaimparklaimcrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMJenisrugi = _sentinel,
		Object? comboRMatauang = _sentinel,
		bool? isDirty,
		bool? isComplete,
	}) {
		return KlaimparklaimcrudState(
			record: identical(record, _sentinel)
					? this.record
					: record as KlaimparklaimcrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMJenisrugi: identical(comboMJenisrugi, _sentinel)
					? this.comboMJenisrugi
					: comboMJenisrugi as ComboMJenisrugiModel?,
			comboRMatauang: identical(comboRMatauang, _sentinel)
					? this.comboRMatauang
					: comboRMatauang as ComboRMatauangModel?,
			isDirty: isDirty ?? this.isDirty,
			isComplete: isComplete ?? this.isComplete,
		);
	}

	@override
	List<Object?> get props => [
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		record ?? '',
		comboMJenisrugi ?? '',
		comboRMatauang ?? '',
		isDirty,
		isComplete,
	];
}