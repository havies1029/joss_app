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

  static const _sentinel = Object();

  SimulparCrudState copyWith({
    Object? record = _sentinel,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    bool? isGroupFieldRateChanged,
    bool? isGroupFieldPremiChanged,
    bool? isGroupFieldSiChanged,
    Object? comboROkupasi = _sentinel,
    Object? comboRKonstruksiojk = _sentinel,
    Object? comboMBiindemnityOjk = _sentinel,
    Object? comboMKabZonaGempa = _sentinel,
    Object? comboMZonaGempa = _sentinel,
    Object? comboMWilayah = _sentinel,
    Object? comboMTarifojkBanjirPar = _sentinel,
    Object? comboRMatauang = _sentinel,
    List<String>? errors,
  }) {
    return SimulparCrudState(
      record: identical(record, _sentinel) ? this.record : record as SimulparCrudModel?,
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
      comboROkupasi: identical(comboROkupasi, _sentinel) ? this.comboROkupasi : comboROkupasi as ComboROkupasiModel?,
      comboRKonstruksiojk: identical(comboRKonstruksiojk, _sentinel) ? this.comboRKonstruksiojk : comboRKonstruksiojk as ComboRKonstruksiojkModel?,
      comboMBiindemnityOjk: identical(comboMBiindemnityOjk, _sentinel) ? this.comboMBiindemnityOjk : comboMBiindemnityOjk as ComboMBiindemnityOjkModel?,
      comboMKabZonaGempa: identical(comboMKabZonaGempa, _sentinel) ? this.comboMKabZonaGempa : comboMKabZonaGempa as ComboMKabZonaGempaModel?,
      comboMZonaGempa: identical(comboMZonaGempa, _sentinel) ? this.comboMZonaGempa : comboMZonaGempa as ComboMZonaGempaModel?,
      comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
      comboMTarifojkBanjirPar: identical(comboMTarifojkBanjirPar, _sentinel) ? this.comboMTarifojkBanjirPar : comboMTarifojkBanjirPar as ComboMTarifojkBanjirParModel?,
      comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        isGroupFieldRateChanged,
        isGroupFieldPremiChanged,
        isGroupFieldSiChanged,
        record ?? '',
        comboROkupasi ?? '',
        comboRKonstruksiojk ?? '',
        comboMBiindemnityOjk ?? '',
        comboMKabZonaGempa ?? '',
        comboMZonaGempa ?? '',
        comboMWilayah ?? '',
        comboMTarifojkBanjirPar ?? '',
        comboRMatauang ?? '',
        errors ?? ''
      ];
}
