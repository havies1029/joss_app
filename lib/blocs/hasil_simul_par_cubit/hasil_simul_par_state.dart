import 'package:equatable/equatable.dart';
import '../../../../../models/combobox/combomkabzonagempa_model.dart';
import '../../../../../models/combobox/combomwilayah_model.dart';
import '../../../../../models/combobox/comborkonstruksiojk_model.dart';
import '../../../../../models/combobox/comborokupasi_model.dart';

class HasilSimulParState extends Equatable {
  final int siBuilding;
  final int siContent;
  final int siMachinery;
  final int siStock;
  final int siOther;
  final int stockAdjustable;

  final double ratePar;
  final double rateEqvet;
  final double rateRsmdcc;
  final double rateTsfwd;
  final double rateOther;
  final double rateTotal;

  final double premiEqvet;
  final double premiRsmdcc;
  final double premiTsfwd;
  final double premiOther;
  final double premiTotal;

  final ComboMWilayahModel wilayah;
  final ComboMKabZonaGempaModel zonaGempa;
  final ComboRKonstruksiojkModel konstruksi;
  final ComboROkupasiModel okupasi;

  const HasilSimulParState({
    this.siBuilding = 0,
    this.siContent = 0,
    this.siMachinery = 0,
    this.siStock = 0,
    this.siOther = 0,
    this.stockAdjustable = 0,
    this.ratePar = 0,
    this.rateEqvet = 0,
    this.rateRsmdcc = 0,
    this.rateTsfwd = 0,
    this.rateOther = 0,
    this.rateTotal = 0,
    this.premiEqvet = 0,
    this.premiRsmdcc = 0,
    this.premiTsfwd = 0,
    this.premiOther = 0,
    this.premiTotal = 0,
    this.wilayah = const ComboMWilayahModel(),
    this.zonaGempa = const ComboMKabZonaGempaModel(),
    this.konstruksi = const ComboRKonstruksiojkModel(),
    this.okupasi = const ComboROkupasiModel(),
  });

  HasilSimulParState copyWith({
    int? siBuilding,
    int? siContent,
    int? siMachinery,
    int? siStock,
    int? siOther,
    int? stockAdjustable,
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
    return HasilSimulParState(
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

  @override
  List<Object?> get props => [
    siBuilding,
    siContent,
    siMachinery,
    siStock,
    siOther,
    stockAdjustable,
    ratePar,
    rateEqvet,
    rateRsmdcc,
    rateTsfwd,
    rateOther,
    rateTotal,
    premiEqvet,
    premiRsmdcc,
    premiTsfwd,
    premiOther,
    premiTotal,
    wilayah,
    zonaGempa,
    konstruksi,
    okupasi,
  ];
}
