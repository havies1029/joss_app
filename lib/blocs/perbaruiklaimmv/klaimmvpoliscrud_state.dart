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
  final bool isValid;
  final String saveFrom;

  const KlaimmvpoliscrudState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.comboMInsurer,
    this.comboMMvjnscover,
    this.isComplete = false,
    this.isDirty = false,
    this.isValid = true,
    this.saveFrom = "",
  });

  static const _noChange = Object();

  KlaimmvpoliscrudState copyWith({
    Object? record = _noChange,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    Object? comboMInsurer = _noChange,
    Object? comboMMvjnscover = _noChange,
    bool? isComplete,
    bool? isDirty,
    bool? isValid,
    String? saveFrom,
  }) {
    return KlaimmvpoliscrudState(
      record: identical(record, _noChange)
          ? this.record
          : record as KlaimmvpoliscrudModel?,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      comboMInsurer: identical(comboMInsurer, _noChange)
          ? this.comboMInsurer
          : comboMInsurer as ComboMInsurerModel?,
      comboMMvjnscover: identical(comboMMvjnscover, _noChange)
          ? this.comboMMvjnscover
          : comboMMvjnscover as ComboMMvjnscoverModel?,
      isComplete: isComplete ?? this.isComplete,
      isDirty: isDirty ?? this.isDirty,
      isValid: isValid ?? this.isValid,
      saveFrom: saveFrom ?? this.saveFrom,
    );
  }

  @override
  List<Object?> get props => [
        record,
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        comboMInsurer,
        comboMMvjnscover,
        isComplete,
        isDirty,
        isValid,
        saveFrom,
      ];
}