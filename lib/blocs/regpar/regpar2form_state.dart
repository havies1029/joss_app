part of 'regpar2form_bloc.dart';

class Regpar2FormState extends Equatable {

	final Regpar2FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboROkupasiModel? comboROkupasi;
	final ComboRKonstruksiojkModel? comboRKonstruksiojk;
	const Regpar2FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboROkupasi,
		this.comboRKonstruksiojk,
});

	Regpar2FormState copyWith({
		Regpar2FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboROkupasiModel? comboROkupasi,
		ComboRKonstruksiojkModel? comboRKonstruksiojk,
	}){
		return Regpar2FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboROkupasi: comboROkupasi?? this.comboROkupasi,
			comboRKonstruksiojk: comboRKonstruksiojk?? this.comboRKonstruksiojk,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
