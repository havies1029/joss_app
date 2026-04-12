part of 'klaim2crud_bloc.dart';

class Klaim2CrudState extends Equatable {

	final Klaim2CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMStsclaimModel? comboMStsclaim;
	const Klaim2CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMStsclaim,
});

  static const _sentinel = Object();

	Klaim2CrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMStsclaim = _sentinel,
	}){
		return Klaim2CrudState(
			record: identical(record, _sentinel) ? this.record : record as Klaim2CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMStsclaim: identical(comboMStsclaim, _sentinel) ? this.comboMStsclaim : comboMStsclaim as ComboMStsclaimModel?,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, comboMStsclaim];
}
