part of 'klaimmvklaimcrud_bloc.dart';

class KlaimmvklaimcrudState extends Equatable {

	final KlaimmvklaimcrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboRMatauangModel? comboRMatauang;
  final bool isComplete;
  final bool isDirty;
	const KlaimmvklaimcrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboRMatauang,
    this.isComplete = false,
    this.isDirty = false
});

	KlaimmvklaimcrudState copyWith({
		KlaimmvklaimcrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboRMatauangModel? comboRMatauang,
    bool? isComplete,
    bool? isDirty,
    }) {
		return KlaimmvklaimcrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
      isComplete: isComplete ?? this.isComplete,
      isDirty: isDirty ?? this.isDirty
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, isComplete, record ?? '', isDirty];
}
