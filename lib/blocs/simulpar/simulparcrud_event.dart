part of 'simulparcrud_bloc.dart';

abstract class SimulparCrudEvents extends Equatable {
  const SimulparCrudEvents();

  @override
  List<Object> get props => [];
}

class SimulparCrudTambahEvent extends SimulparCrudEvents {
  final SimulparCrudModel record;
  const SimulparCrudTambahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class SimulparCrudUbahEvent extends SimulparCrudEvents {
  final SimulparCrudModel record;
  const SimulparCrudUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class SimulparCrudHapusEvent extends SimulparCrudEvents {
  final String recordId;
  const SimulparCrudHapusEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class SimulparCrudLihatEvent extends SimulparCrudEvents {
  final String recordId;
  const SimulparCrudLihatEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class SimulPARCrudInitValueEvent extends SimulparCrudEvents {}

class ComboROkupasiChangedEvent extends SimulparCrudEvents {
  final ComboROkupasiModel comboROkupasi;
  const ComboROkupasiChangedEvent({required this.comboROkupasi});

  @override
  List<Object> get props => [comboROkupasi];
}

class ComboRKonstruksiojkChangedEvent extends SimulparCrudEvents {
  final ComboRKonstruksiojkModel comboRKonstruksiojk;
  const ComboRKonstruksiojkChangedEvent({required this.comboRKonstruksiojk});

  @override
  List<Object> get props => [comboRKonstruksiojk];
}

class ComboMBiindemnityOjkChangedEvent extends SimulparCrudEvents {
  final ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
  const ComboMBiindemnityOjkChangedEvent({required this.comboMBiindemnityOjk});

  @override
  List<Object> get props => [];
}

class ComboMKabZonaGempaChangedEvent extends SimulparCrudEvents {
  final ComboMKabZonaGempaModel comboMKabZonaGempa;
  const ComboMKabZonaGempaChangedEvent({required this.comboMKabZonaGempa});

  @override
  List<Object> get props => [comboMKabZonaGempa];
}

class ComboMZonaGempaChangedEvent extends SimulparCrudEvents {
  final ComboMZonaGempaModel comboMZonaGempa;
  const ComboMZonaGempaChangedEvent({required this.comboMZonaGempa});

  @override
  List<Object> get props => [comboMZonaGempa];
}

class ComboMWilayahChangedEvent extends SimulparCrudEvents {
  final ComboMWilayahModel? comboMWilayah;
  const ComboMWilayahChangedEvent({required this.comboMWilayah});

  @override
  List<Object> get props => [];
}

class ComboMTarifojkBanjirParChangedEvent extends SimulparCrudEvents {
  final ComboMTarifojkBanjirParModel comboMTarifojkBanjirPar;
  const ComboMTarifojkBanjirParChangedEvent(
      {required this.comboMTarifojkBanjirPar});

  @override
  List<Object> get props => [comboMTarifojkBanjirPar];
}

class GetRateBawahFlexasEvent extends SimulparCrudEvents {
  final String okupasiId;
  final String konstruksiId;

  const GetRateBawahFlexasEvent(
      {required this.okupasiId, required this.konstruksiId});

  @override
  List<Object> get props => [okupasiId, konstruksiId];
}

class GetRateBawahTsfwdEvent extends SimulparCrudEvents {
  final String wilayahId;

  const GetRateBawahTsfwdEvent({required this.wilayahId});

  @override
  List<Object> get props => [wilayahId];
}

class FieldRateRsmdccChangedEvent extends SimulparCrudEvents {
  final double rateRsmdcc;

  const FieldRateRsmdccChangedEvent({required this.rateRsmdcc});

  @override
  List<Object> get props => [rateRsmdcc];
}

class FieldRateOthersChangedEvent extends SimulparCrudEvents {
  final double rate;

  const FieldRateOthersChangedEvent({required this.rate});

  @override
  List<Object> get props => [rate];
}

class GetRateBawahEqvetEvent extends SimulparCrudEvents {
  final String okupasiId;
  final String kabupatenId;

  const GetRateBawahEqvetEvent(
      {required this.okupasiId, required this.kabupatenId});

  @override
  List<Object> get props => [okupasiId, kabupatenId];
}

class HitungPremiPAREvent extends SimulparCrudEvents {}

class FieldSiBuildingChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiBuildingChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class FieldSiContentChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiContentChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class FieldSiMachineryChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiMachineryChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class FieldSiOthersChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiOthersChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class FieldSiStockChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiStockChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class FieldStockAdjustableChangedEvent extends SimulparCrudEvents {
  final double adjustable;

  const FieldStockAdjustableChangedEvent({required this.adjustable});

  @override
  List<Object> get props => [adjustable];
}

class FieldSiBiChangedEvent extends SimulparCrudEvents {
  final double si;

  const FieldSiBiChangedEvent({required this.si});

  @override
  List<Object> get props => [si];
}

class ComboRMatauangChangedEvent extends SimulparCrudEvents {
  final ComboRMatauangModel comboRMatauang;
  const ComboRMatauangChangedEvent({required this.comboRMatauang});

  @override
  List<Object> get props => [comboRMatauang];
}

class FieldBulanChangedEvent extends SimulparCrudEvents {
  final int bulan;
  const FieldBulanChangedEvent({required this.bulan});

  @override
  List<Object> get props => [bulan];

}
