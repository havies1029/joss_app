part of 'mrekanbankcrud_bloc.dart';

class MRekanBankCrudState extends Equatable {
	final MRekanBankCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMBankModel? comboMBank;

	const MRekanBankCrudState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMBank,
	});

	static const _unset = Object();

	MRekanBankCrudState copyWith({
		Object? record = _unset,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMBank = _unset,
	}) {
		return MRekanBankCrudState(
			record: record == _unset ? this.record : record as MRekanBankCrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMBank: comboMBank == _unset ? this.comboMBank : comboMBank as ComboMBankModel?,
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
		comboMBank,
	];
}