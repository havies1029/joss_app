import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/app_prefs.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';

import '../../models/combobox/comborkonstruksiojk_model.dart';

class SimulasiParLocalState {
  // SUM INSURED
  final double? siBuilding;
  final double? siContent;
  final double? siMachinery;
  final double? siStock;
  final double? siOther;
  final double? stockAdjustable;

  // RATE
  final double? ratePar;
  final double? rateEqvet;
  final double? rateRsmdcc;
  final double? rateTsfwd;
  final double? rateOther;
  final double? rateTotal;

  // PREMI
  final double? premiEqvet;
  final double? premiRsmdcc;
  final double? premiTsfwd;
  final double? premiOther;
  final double? premiTotal;

  // COMBO
  final ComboMWilayahModel? wilayah;
  final ComboMKabZonaGempaModel? zonaGempa;
  final ComboRKonstruksiojkModel? konstruksi;
  final ComboROkupasiModel? okupasi;

  const SimulasiParLocalState({
    this.siBuilding,
    this.siContent,
    this.siMachinery,
    this.siStock,
    this.siOther,
    this.stockAdjustable,
    this.ratePar,
    this.rateEqvet,
    this.rateRsmdcc,
    this.rateTsfwd,
    this.rateOther,
    this.rateTotal,
    this.premiEqvet,
    this.premiRsmdcc,
    this.premiTsfwd,
    this.premiOther,
    this.premiTotal,
    this.wilayah,
    this.zonaGempa,
    this.konstruksi,
    this.okupasi,
  });

  SimulasiParLocalState copyWith({
    double? siBuilding,
    double? siContent,
    double? siMachinery,
    double? siStock,
    double? siOther,
    double? stockAdjustable,
    double? ratePar,
    double? rateEqvet,
    double? rateRsmdcc,
    double? rateTsfwd,
    double? rateOther,
    double? rateTotal,
    double? premiEqvet,
    double? premiRsmdcc,
    double? premiTsfwd,
    double? premiOther,
    double? premiTotal,
    ComboMWilayahModel? wilayah,
    ComboMKabZonaGempaModel? zonaGempa,
    ComboRKonstruksiojkModel? konstruksi,
    ComboROkupasiModel? okupasi,
  }) {
    return SimulasiParLocalState(
      siBuilding: siBuilding ?? this.siBuilding,
      siContent: siContent ?? this.siContent,
      siMachinery: siMachinery ?? this.siMachinery,
      siStock: siStock ?? this.siStock,
      siOther: siOther ?? this.siOther,
      stockAdjustable: stockAdjustable ?? this.stockAdjustable,
      ratePar: ratePar ?? this.ratePar,
      rateEqvet: rateEqvet ?? this.rateEqvet,
      rateRsmdcc: rateRsmdcc ?? this.rateRsmdcc,
      rateTsfwd: rateTsfwd ?? this.rateTsfwd,
      rateOther: rateOther ?? this.rateOther,
      rateTotal: rateTotal ?? this.rateTotal,
      premiEqvet: premiEqvet ?? this.premiEqvet,
      premiRsmdcc: premiRsmdcc ?? this.premiRsmdcc,
      premiTsfwd: premiTsfwd ?? this.premiTsfwd,
      premiOther: premiOther ?? this.premiOther,
      premiTotal: premiTotal ?? this.premiTotal,
      wilayah: wilayah ?? this.wilayah,
      zonaGempa: zonaGempa ?? this.zonaGempa,
      konstruksi: konstruksi ?? this.konstruksi,
      okupasi: okupasi ?? this.okupasi,
    );
  }
}

class SimulasiParLocalCubit extends Cubit<SimulasiParLocalState> {
  final AppPrefs prefs;
  SimulasiParLocalCubit(this.prefs) : super(const SimulasiParLocalState());

  void setFromSimulasi({
    required double siBuilding,
    required double siContent,
    required double siMachinery,
    required double siStock,
    required double siOther,
    required double stockAdjustable,
    required double ratePar,
    required double rateEqvet,
    required double rateRsmdcc,
    required double rateTsfwd,
    required double rateOther,
    required double rateTotal,
    required double premiEqvet,
    required double premiRsmdcc,
    required double premiTsfwd,
    required double premiOther,
    required double premiTotal,
    required ComboMWilayahModel wilayah,
    required ComboMKabZonaGempaModel zonaGempa,
    required ComboRKonstruksiojkModel konstruksi,
    required ComboROkupasiModel okupasi,
  }) {
    emit(SimulasiParLocalState(
      siBuilding: siBuilding,
      siContent: siContent,
      siMachinery: siMachinery,
      siStock: siStock,
      siOther: siOther,
      stockAdjustable: stockAdjustable,
      ratePar: ratePar,
      rateEqvet: rateEqvet,
      rateRsmdcc: rateRsmdcc,
      rateTsfwd: rateTsfwd,
      rateOther: rateOther,
      rateTotal: rateTotal,
      premiEqvet: premiEqvet,
      premiRsmdcc: premiRsmdcc,
      premiTsfwd: premiTsfwd,
      premiOther: premiOther,
      premiTotal: premiTotal,
      wilayah: wilayah,
      zonaGempa: zonaGempa,
      konstruksi: konstruksi,
      okupasi: okupasi,
    ));
  }

  void clear() => emit(const SimulasiParLocalState());
}
