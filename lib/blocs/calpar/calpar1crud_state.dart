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

	Calpar1CrudState copyWith({
		Calpar1CrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboROkupasiModel? comboROkupasi,
		ComboRKonstruksiojkModel? comboRKonstruksiojk,
		ComboMJnscoverParModel? comboMJnscoverPar,
	}){
		return Calpar1CrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboROkupasi: comboROkupasi?? this.comboROkupasi,
			comboRKonstruksiojk: comboRKonstruksiojk?? this.comboRKonstruksiojk,
			comboMJnscoverPar: comboMJnscoverPar?? this.comboMJnscoverPar,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
