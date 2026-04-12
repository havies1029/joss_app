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

  static const _sentinel = Object();

	Regklaim1CrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMInsurance = _sentinel,
    String? regklaim1Id,
    String? viewMode,
	}){
		return Regklaim1CrudState(
			record: identical(record, _sentinel) ? this.record : record as Regklaim1CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMInsurance: identical(comboMInsurance, _sentinel) ? this.comboMInsurance : comboMInsurance as ComboMInsuranceModel?,
      regklaim1Id: regklaim1Id ?? this.regklaim1Id,
      viewMode: viewMode ?? this.viewMode,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, record ?? '', comboMInsurance ?? '', regklaim1Id, viewMode];
}
