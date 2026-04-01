part of 'mrekangeneralidvcrud_bloc.dart';

class MRekanGeneralIdvCrudState extends Equatable {
  final MRekanGeneralIdvCrudModel? record;
  final bool isLoading;
  final bool isLoaded;
  final bool isSaving;
  final bool isSaved;
  final bool hasFailure;
  final ComboMPekerjaanModel? comboMPekerjaan;
  final ComboMJnskelModel? comboMJnskel;
  final bool isDataComplete;

  const MRekanGeneralIdvCrudState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.comboMPekerjaan,
    this.comboMJnskel,
    this.isDataComplete = false,
  });

  static const _unset = Object();

  MRekanGeneralIdvCrudState copyWith({
    Object? record = _unset,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    Object? comboMPekerjaan = _unset,
    Object? comboMJnskel = _unset,
    bool? isDataComplete,
  }) {
    return MRekanGeneralIdvCrudState(
      record: record == _unset ? this.record : record as MRekanGeneralIdvCrudModel?,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      comboMPekerjaan: comboMPekerjaan == _unset
          ? this.comboMPekerjaan
          : comboMPekerjaan as ComboMPekerjaanModel?,
      comboMJnskel: comboMJnskel == _unset
          ? this.comboMJnskel
          : comboMJnskel as ComboMJnskelModel?,
      isDataComplete: isDataComplete ?? this.isDataComplete,
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
    comboMPekerjaan,
    comboMJnskel,
    isDataComplete,
  ];
}