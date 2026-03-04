part of 'simulparcrud_bloc.dart';

class SimulparCrudState extends Equatable {
  final SimulparCrudModel? record;
  final bool isLoading;
  final bool isLoaded;
  final bool isSaving;
  final bool isSaved;
  final bool hasFailure;
  final bool isGroupFieldRateChanged;
  final bool isGroupFieldPremiChanged;
  final bool isGroupFieldSiChanged;
  final ComboROkupasiModel? comboROkupasi;
  final ComboRKonstruksiojkModel? comboRKonstruksiojk;
  final ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
  final ComboMKabZonaGempaModel? comboMKabZonaGempa;
  final ComboMZonaGempaModel? comboMZonaGempa;
  final ComboMWilayahModel? comboMWilayah;
  final ComboMTarifojkBanjirParModel? comboMTarifojkBanjirPar;
	final ComboRMatauangModel? comboRMatauang;
  final List<String>? errors;
  const SimulparCrudState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.isGroupFieldRateChanged = false,
    this.isGroupFieldPremiChanged = false,
    this.isGroupFieldSiChanged = false,
    this.comboROkupasi,
    this.comboRKonstruksiojk,
    this.comboMBiindemnityOjk,
    this.comboMKabZonaGempa,
    this.comboMZonaGempa,
    this.comboMWilayah,
    this.comboMTarifojkBanjirPar,
    this.comboRMatauang,
    this.errors,
  });

  SimulparCrudState copyWith({
    SimulparCrudModel? record,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    bool? isGroupFieldRateChanged,
    bool? isGroupFieldPremiChanged,
    bool? isGroupFieldSiChanged,
    ComboROkupasiModel? comboROkupasi,
    ComboRKonstruksiojkModel? comboRKonstruksiojk,
    ComboMBiindemnityOjkModel? comboMBiindemnityOjk,
    ComboMKabZonaGempaModel? comboMKabZonaGempa,
    ComboMZonaGempaModel? comboMZonaGempa,
    ComboMWilayahModel? comboMWilayah,
    ComboMTarifojkBanjirParModel? comboMTarifojkBanjirPar,
    ComboRMatauangModel? comboRMatauang,
    List<String>? errors,
  }) {
    return SimulparCrudState(
      record: record ?? this.record,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasFailure: hasFailure ?? this.hasFailure,
      isGroupFieldRateChanged:
          isGroupFieldRateChanged ?? this.isGroupFieldRateChanged,
      isGroupFieldPremiChanged:
          isGroupFieldPremiChanged ?? this.isGroupFieldPremiChanged,
      isGroupFieldSiChanged: isGroupFieldSiChanged ?? this.isGroupFieldSiChanged,
      comboROkupasi: comboROkupasi ?? this.comboROkupasi,
      comboRKonstruksiojk: comboRKonstruksiojk ?? this.comboRKonstruksiojk,
      comboMBiindemnityOjk: comboMBiindemnityOjk ?? this.comboMBiindemnityOjk,
      comboMKabZonaGempa: comboMKabZonaGempa ?? this.comboMKabZonaGempa,
      comboMZonaGempa: comboMZonaGempa ?? this.comboMZonaGempa,
      comboMWilayah: comboMWilayah ?? this.comboMWilayah,
      comboMTarifojkBanjirPar:
          comboMTarifojkBanjirPar ?? this.comboMTarifojkBanjirPar,
      comboRMatauang: comboRMatauang ?? this.comboRMatauang,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        isGroupFieldRateChanged,
        isGroupFieldPremiChanged,
        isGroupFieldSiChanged
      ];
}
