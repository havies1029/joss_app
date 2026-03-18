part of 'regother1crud_bloc.dart';

class Regother1CrudState extends Equatable {

	final Regother1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMCobApp1Model? comboMCobApp1;
	final ComboRMatauangModel? comboRMatauang;
	final Regother1CrudModel? selectedItem;
	final String selectedCOBId;
	final String namaCob;
	const Regother1CrudState(
			{this.record,
				this.selectedItem,
				this.selectedCOBId = '',
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboMCobApp1,
				this.comboRMatauang,
				this.namaCob = '',
			});

	Regother1CrudState copyWith({
		Regother1CrudModel? record,
		Regother1CrudModel? selectedItem,
		String? selectedCOBId,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMCobApp1Model? comboMCobApp1,
		ComboRMatauangModel? comboRMatauang,
		String? namaCob,
	}){
		return Regother1CrudState(
			record: record ?? this.record,
			selectedItem: selectedItem ?? this.selectedItem,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMCobApp1: comboMCobApp1?? this.comboMCobApp1,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
			selectedCOBId: selectedCOBId ?? this.selectedCOBId,
			namaCob: namaCob ?? this.namaCob,
		);
	}

	factory Regother1CrudState.initial() {
		return Regother1CrudState(
			record: null,
			isLoading: false,
			isLoaded: false,
			isSaving: false,
			isSaved: false,
			hasFailure: false,
			comboMCobApp1: null,
			comboRMatauang: null,
		);
	}


	@override
	List<Object?> get props => [record, selectedItem, isLoading, isLoaded, isSaving, isSaved, hasFailure, selectedCOBId, namaCob];
}
