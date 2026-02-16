part of 'klaimmvbengkelcrud_bloc.dart';

class KlaimmvbengkelcrudState extends Equatable {

	final KlaimmvbengkelcrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMJnsbengkelModel? comboMJnsbengkel;
	final ComboMWilayahBengkelModel? comboMWilayahBengkel;
	final ComboMBengkelModel? comboMBengkel;
  final bool isComplete;
  final bool isDirty;

	const KlaimmvbengkelcrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMJnsbengkel,
		this.comboMWilayahBengkel,
		this.comboMBengkel,
    this.isComplete = false,
    this.isDirty = false
});

	KlaimmvbengkelcrudState copyWith({
		KlaimmvbengkelcrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMJnsbengkelModel? comboMJnsbengkel,
		Object? comboMWilayahBengkel = _sentinel,
		Object? comboMBengkel = _sentinel,
    bool? isComplete,
    bool? isDirty,
	}){
		return KlaimmvbengkelcrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMJnsbengkel: comboMJnsbengkel?? this.comboMJnsbengkel,
			comboMWilayahBengkel: comboMWilayahBengkel == _sentinel ? this.comboMWilayahBengkel : comboMWilayahBengkel as ComboMWilayahBengkelModel?,
			comboMBengkel: comboMBengkel == _sentinel ? this.comboMBengkel : comboMBengkel as ComboMBengkelModel?,
      isComplete: isComplete ?? this.isComplete,
      isDirty: isDirty ?? this.isDirty
		);
	}

  static const _sentinel = Object();

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, isComplete, record ?? '', isDirty];
}
