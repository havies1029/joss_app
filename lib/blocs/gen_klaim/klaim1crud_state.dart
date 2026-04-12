part of 'klaim1crud_bloc.dart';

class Klaim1CrudState extends Equatable {

	final Klaim1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboRMatauangModel? comboRMatauang;
	final ComboMStsclaimModel? comboMStsclaim;
	const Klaim1CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboRMatauang,
		this.comboMStsclaim,
});

  static const _sentinel = Object();

	Klaim1CrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboRMatauang = _sentinel,
		Object? comboMStsclaim = _sentinel,
	}){
		return Klaim1CrudState(
			record: identical(record, _sentinel) ? this.record : record as Klaim1CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
			comboMStsclaim: identical(comboMStsclaim, _sentinel) ? this.comboMStsclaim : comboMStsclaim as ComboMStsclaimModel?,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, comboRMatauang, comboMStsclaim];
}
