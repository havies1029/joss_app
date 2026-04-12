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
  final bool isValid;
  final String saveFrom;

  const KlaimmvbengkelcrudState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.comboMJnsbengkel,
    this.comboMWilayahBengkel,
    this.comboMBengkel,
    this.isComplete = false,
    this.isDirty = false,
    this.isValid = true,
    this.saveFrom = "",
  });

  static const _sentinel = Object();

  KlaimmvbengkelcrudState copyWith({
    Object? record = _sentinel,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    Object? comboMJnsbengkel = _sentinel,
    Object? comboMWilayahBengkel = _sentinel,
    Object? comboMBengkel = _sentinel,
    bool? isComplete,
    bool? isDirty,
    bool? isValid,
    String? saveFrom,
  }) {
    return KlaimmvbengkelcrudState(
      record: identical(record, _sentinel)
          ? this.record
          : record as KlaimmvbengkelcrudModel?,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      comboMJnsbengkel: identical(comboMJnsbengkel, _sentinel)
          ? this.comboMJnsbengkel
          : comboMJnsbengkel as ComboMJnsbengkelModel?,
      comboMWilayahBengkel: identical(comboMWilayahBengkel, _sentinel)
          ? this.comboMWilayahBengkel
          : comboMWilayahBengkel as ComboMWilayahBengkelModel?,
      comboMBengkel: identical(comboMBengkel, _sentinel)
          ? this.comboMBengkel
          : comboMBengkel as ComboMBengkelModel?,
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
        comboMJnsbengkel,
        comboMWilayahBengkel,
        comboMBengkel,
        isComplete,
        isDirty,
        isValid,
        saveFrom,
      ];
}