part of 'rekanbank_bloc.dart';

class RekanBankState extends Equatable {

	final RekanBankModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMBankModel? comboMBank;
	const RekanBankState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMBank,
});

  static const _sentinel = Object();

	RekanBankState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMBank = _sentinel,
	}){
		return RekanBankState(
			record: identical(record, _sentinel) ? this.record : record as RekanBankModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMBank: identical(comboMBank, _sentinel) ? this.comboMBank : comboMBank as ComboMBankModel?,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, record ?? '', comboMBank ?? ''];
}
