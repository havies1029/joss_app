part of 'regklaim1crud_bloc.dart';

class Regklaim1CrudState extends Equatable {

	final Regklaim1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMInsuranceModel? comboMInsurance;
  final String regklaim1Id;
  final String viewMode;

	const Regklaim1CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMInsurance,
    this.regklaim1Id = "",
    this.viewMode = 'tambah',
});

	Regklaim1CrudState copyWith({
		Regklaim1CrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMInsuranceModel? comboMInsurance,
    String? regklaim1Id,
    String? viewMode,
	}){
		return Regklaim1CrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMInsurance: comboMInsurance?? this.comboMInsurance,
      regklaim1Id: regklaim1Id ?? this.regklaim1Id,
      viewMode: viewMode ?? this.viewMode,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, regklaim1Id, viewMode, record];
}
