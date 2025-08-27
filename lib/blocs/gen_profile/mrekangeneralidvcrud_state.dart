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
  const MRekanGeneralIdvCrudState(
      {this.record,
        this.isLoading = false,
        this.isLoaded = false,
        this.isSaving = false,
        this.isSaved = false,
        this.hasFailure = false,
        this.comboMPekerjaan,
        this.comboMJnskel});

  MRekanGeneralIdvCrudState copyWith(
      {MRekanGeneralIdvCrudModel? record,
        bool? isLoading,
        bool? isLoaded,
        bool? isSaving,
        bool? isSaved,
        bool? hasFailure,
        ComboMPekerjaanModel? comboMPekerjaan,
        ComboMJnskelModel? comboMJnskel}) {
    return MRekanGeneralIdvCrudState(
      record: record ?? this.record,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      comboMPekerjaan: comboMPekerjaan ?? this.comboMPekerjaan,
      comboMJnskel: comboMJnskel ?? this.comboMJnskel,
    );
  }

  @override
  List<Object> get props =>
      [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
