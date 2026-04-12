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

  static const _sentinel = Object();

	Regother1CrudState copyWith({
		Object? record = _sentinel,
		Object? selectedItem = _sentinel,
		String? selectedCOBId,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMCobApp1 = _sentinel,
		Object? comboRMatauang = _sentinel,
		String? namaCob,
	}){
		return Regother1CrudState(
			record: identical(record, _sentinel) ? this.record : record as Regother1CrudModel?,
			selectedItem: identical(selectedItem, _sentinel) ? this.selectedItem : selectedItem as Regother1CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMCobApp1: identical(comboMCobApp1, _sentinel) ? this.comboMCobApp1 : comboMCobApp1 as ComboMCobApp1Model?,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
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
	List<Object?> get props => [record ?? '', selectedItem ?? '', isLoading, isLoaded, isSaving, isSaved, hasFailure, selectedCOBId, namaCob, comboMCobApp1 ?? '', comboRMatauang ?? ''];
}
