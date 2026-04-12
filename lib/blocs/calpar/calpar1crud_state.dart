part of 'calpar1crud_bloc.dart';

class Calpar1CrudState extends Equatable {

	final Calpar1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboROkupasiModel? comboROkupasi;
	final ComboRKonstruksiojkModel? comboRKonstruksiojk;
	final ComboMJnscoverParModel? comboMJnscoverPar;
	const Calpar1CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboROkupasi,
		this.comboRKonstruksiojk,
		this.comboMJnscoverPar,
});

  static const _sentinel = Object();

	Calpar1CrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboROkupasi = _sentinel,
		Object? comboRKonstruksiojk = _sentinel,
		Object? comboMJnscoverPar = _sentinel,
	}){
		return Calpar1CrudState(
			record: identical(record, _sentinel) ? this.record : record as Calpar1CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboROkupasi: identical(comboROkupasi, _sentinel) ? this.comboROkupasi : comboROkupasi as ComboROkupasiModel?,
			comboRKonstruksiojk: identical(comboRKonstruksiojk, _sentinel) ? this.comboRKonstruksiojk : comboRKonstruksiojk as ComboRKonstruksiojkModel?,
			comboMJnscoverPar: identical(comboMJnscoverPar, _sentinel) ? this.comboMJnscoverPar : comboMJnscoverPar as ComboMJnscoverParModel?,
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
		comboROkupasi,
		comboRKonstruksiojk,
		comboMJnscoverPar,
	];

}
