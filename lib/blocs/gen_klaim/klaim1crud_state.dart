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

	Klaim1CrudState copyWith({
		Klaim1CrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboRMatauangModel? comboRMatauang,
		ComboMStsclaimModel? comboMStsclaim,
	}){
		return Klaim1CrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
			comboMStsclaim: comboMStsclaim?? this.comboMStsclaim,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
