part of 'calpar2form_bloc.dart';

class Calpar2FormState extends Equatable {

	final Calpar2FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ReturnDataAPI? returnData;
	final ComboRMatauangModel? comboRMatauang;
	final ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
	const Calpar2FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
			this.returnData,

			this.comboRMatauang,
		this.comboMBiindemnityOjk,
});

  static const _sentinel = Object();

	Calpar2FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? returnData = _sentinel,
		Object? comboRMatauang = _sentinel,
		Object? comboMBiindemnityOjk = _sentinel,
	}){
		return Calpar2FormState(
			record: identical(record, _sentinel) ? this.record : record as Calpar2FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			returnData: identical(returnData, _sentinel) ? this.returnData : returnData as ReturnDataAPI?,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
			comboMBiindemnityOjk: identical(comboMBiindemnityOjk, _sentinel) ? this.comboMBiindemnityOjk : comboMBiindemnityOjk as ComboMBiindemnityOjkModel?,
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
		comboRMatauang,
		comboMBiindemnityOjk,
	];
}
