part of 'klaimmvpoliscrud_bloc.dart';

class KlaimmvpoliscrudState extends Equatable {

	final KlaimmvpoliscrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMInsurerModel? comboMInsurer;
	final ComboMMvjnscoverModel? comboMMvjnscover;
  final bool isComplete;
  final bool isDirty;
	const KlaimmvpoliscrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMInsurer,
		this.comboMMvjnscover,
    this.isComplete = false,
    this.isDirty = false,
});

	KlaimmvpoliscrudState copyWith({
		KlaimmvpoliscrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMInsurerModel? comboMInsurer,
		ComboMMvjnscoverModel? comboMMvjnscover,
    bool? isComplete,
    bool? isDirty,
	}){
		return KlaimmvpoliscrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMInsurer: comboMInsurer?? this.comboMInsurer,
			comboMMvjnscover: comboMMvjnscover?? this.comboMMvjnscover,
      isComplete: isComplete ?? this.isComplete,
      isDirty: isDirty ?? this.isDirty,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, isComplete, record??'', isDirty];
}
