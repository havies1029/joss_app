import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomzonagempa_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class SimulparCrudModel {
  double? biIndexRate;
  int? coverBulan;
  double? discNilai;
  double? discPersen;
  double? premiFlexas;
  double? premiRsmdcc;
  double? premiTsfwd;
  double? premiEqvet;
  double? premiOthers;
  double? premiBi;
  double? premiTotal;
  double? rateEqvet;
  double? rateOther;
  double? ratePar;
  double? rateRsmdcc;
  double? rateTotal;
  double? rateTsfwd;
  double? siBi;
  double? siBuilding;
  double? siContent;
  double? siMachinery;
  double? siOther;
  double? siStock;
  double? siTotal;
  String? simulpar1Id;
  double? stockAdjustable;
  String? theinsured;
  String? kab2zonagempaId;
  ComboMKabZonaGempaModel? comboMKabZonaGempa;
  String? mbiindemnityojkId;
  ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
  String? mwilayahId;
  ComboMWilayahModel? comboMWilayah;
  String? mzonagempaId;
  ComboMZonaGempaModel? comboMZonaGempa;
  String? rkonstruksiojkId;
  ComboRKonstruksiojkModel? comboRKonstruksiojk;
  String? rokupasiId;
  ComboROkupasiModel? comboROkupasi;
  String? currDesc;
	String? rmatauangKode;
	ComboRMatauangModel? comboRMatauang;

  SimulparCrudModel(
      {this.biIndexRate,
      this.coverBulan,
      this.discNilai,
      this.discPersen,
      this.premiFlexas,
      this.premiRsmdcc,
      this.premiTsfwd,
      this.premiEqvet,
      this.premiOthers,
      this.premiBi,
      this.premiTotal,
      this.rateEqvet,
      this.rateOther,
      this.ratePar,
      this.rateRsmdcc,
      this.rateTotal,
      this.rateTsfwd,
      this.siBi,
      this.siBuilding,
      this.siContent,
      this.siMachinery,
      this.siOther,
      this.siStock,
      this.siTotal,
      this.simulpar1Id,
      this.stockAdjustable,
      this.theinsured,
      this.kab2zonagempaId,
      this.comboMKabZonaGempa,
      this.mbiindemnityojkId,
      this.comboMBiindemnityOjk,
      this.mwilayahId,
      this.comboMWilayah,
      this.mzonagempaId,
      this.comboMZonaGempa,
      this.rkonstruksiojkId,
      this.comboRKonstruksiojk,
      this.rokupasiId,
      this.comboROkupasi,
      this.currDesc = 'Rp.',
      this.rmatauangKode,
      this.comboRMatauang});

  factory SimulparCrudModel.fromJson(Map<String, dynamic> data) {
    ComboMKabZonaGempaModel? comboMKabZonaGempa;
    if (data['comboMKabZonaGempa'] != null) {
      comboMKabZonaGempa =
          ComboMKabZonaGempaModel.fromJson(data['comboMKabZonaGempa']);
    }

    ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
    if (data['comboMBiindemnityOjk'] != null) {
      comboMBiindemnityOjk =
          ComboMBiindemnityOjkModel.fromJson(data['comboMBiindemnityOjk']);
    }

    ComboMWilayahModel? comboMWilayah;
    if (data['comboMWilayah'] != null) {
      comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
    }

    ComboMZonaGempaModel? comboMZonaGempa;
    if (data['comboMZonaGempa'] != null) {
      comboMZonaGempa = ComboMZonaGempaModel.fromJson(data['comboMZonaGempa']);
    }

    ComboRKonstruksiojkModel? comboRKonstruksiojk;
    if (data['comboRKonstruksiojk'] != null) {
      comboRKonstruksiojk =
          ComboRKonstruksiojkModel.fromJson(data['comboRKonstruksiojk']);
    }

    ComboROkupasiModel? comboROkupasi;
    if (data['comboROkupasi'] != null) {
      comboROkupasi = ComboROkupasiModel.fromJson(data['comboROkupasi']);
    }

    
    ComboRMatauangModel? comboRMatauang;
    if (data['comboRMatauang'] != null) {
      comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
    }

    return SimulparCrudModel(
        biIndexRate: double.tryParse(data['biIndexRate'].toString()) ?? 0,
        coverBulan: int.tryParse(data['coverBulan'].toString()) ?? 0,
        discNilai: double.tryParse(data['discNilai'].toString()) ?? 0,
        discPersen: double.tryParse(data['discPersen'].toString()) ?? 0,        
        premiFlexas: double.tryParse(data['premiFlexas'].toString()) ?? 0,
        premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString()) ?? 0,
        premiTsfwd: double.tryParse(data['premiTsfwd'].toString()) ?? 0,
        premiEqvet: double.tryParse(data['premiEqvet'].toString()) ?? 0,
        premiOthers: double.tryParse(data['premiOthers'].toString()) ?? 0,
        premiBi: double.tryParse(data['premiBi'].toString()) ?? 0,
        premiTotal: double.tryParse(data['premiTotal'].toString()) ?? 0,
        rateEqvet: double.tryParse(data['rateEqvet'].toString()) ?? 0,
        rateOther: double.tryParse(data['rateOther'].toString()) ?? 0,
        ratePar: double.tryParse(data['ratePar'].toString()) ?? 0,
        rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString()) ?? 0,
        rateTotal: double.tryParse(data['rateTotal'].toString()) ?? 0,
        rateTsfwd: double.tryParse(data['rateTsfwd'].toString()) ?? 0,
        siBi: double.tryParse(data['siBi'].toString()) ?? 0,
        siBuilding: double.tryParse(data['siBuilding'].toString()) ?? 0,
        siContent: double.tryParse(data['siContent'].toString()) ?? 0,
        siMachinery: double.tryParse(data['siMachinery'].toString()) ?? 0,
        siOther: double.tryParse(data['siOther'].toString()) ?? 0,
        siStock: double.tryParse(data['siStock'].toString()) ?? 0,
        siTotal: double.tryParse(data['siTotal'].toString()) ?? 0,
        simulpar1Id: data['simulpar1Id'] ?? '',
        stockAdjustable:
            double.tryParse(data['stockAdjustable'].toString()) ?? 0,
        theinsured: data['theinsured'] ?? '',
        kab2zonagempaId: data['kab2zonagempaId'] ?? '',
        comboMKabZonaGempa: comboMKabZonaGempa,
        mbiindemnityojkId: data['mbiindemnityojkId'] ?? '',
        comboMBiindemnityOjk: comboMBiindemnityOjk,
        mwilayahId: data['mwilayahId'] ?? '',
        comboMWilayah: comboMWilayah,
        mzonagempaId: data['mzonagempaId'] ?? '',
        comboMZonaGempa: comboMZonaGempa,
        rkonstruksiojkId: data['rkonstruksiojkId'] ?? '',
        comboRKonstruksiojk: comboRKonstruksiojk,
        rokupasiId: data['rokupasiId'] ?? '',
        comboROkupasi: comboROkupasi,
        currDesc: data['currDesc'] ?? 'IDR',
        comboRMatauang: comboRMatauang,
        rmatauangKode: data['rmatauangKode'] ?? ""
      );
  }

  Map<String, dynamic> toJson() => {
        'biIndexRate': biIndexRate.toString(),
        'coverBulan': coverBulan.toString(),
        'discNilai': discNilai.toString(),
        'discPersen': discPersen.toString(),
        'premiNonBi': premiFlexas.toString(),
        'premiRsmdcc': premiRsmdcc.toString(),
        'premiTsfwd': premiTsfwd.toString(),
        'premiEqvet': premiEqvet.toString(),
        'premiOthers': premiOthers.toString(),
        'premiBi': premiBi.toString(),
        'premiTotal': premiTotal.toString(),
        'rateEqvet': rateEqvet.toString(),
        'rateOther': rateOther.toString(),
        'ratePar': ratePar.toString(),
        'rateRsmdcc': rateRsmdcc.toString(),
        'rateTotal': rateTotal.toString(),
        'rateTsfwd': rateTsfwd.toString(),
        'siBi': siBi.toString(),
        'siBuilding': siBuilding.toString(),
        'siContent': siContent.toString(),
        'siMachinery': siMachinery.toString(),
        'siOther': siOther.toString(),
        'siStock': siStock.toString(),
        'siTotal': siTotal.toString(),
        'simulpar1Id': simulpar1Id,
        'stockAdjustable': stockAdjustable.toString(),
        'theinsured': theinsured,
        'kab2zonagempaId': kab2zonagempaId,
        'comboMKabZonaGempa': comboMKabZonaGempa?.toJson(),
        'mbiindemnityojkId': mbiindemnityojkId,
        'comboMBiindemnityOjk': comboMBiindemnityOjk?.toJson(),
        'mwilayahId': mwilayahId,
        'comboMWilayah': comboMWilayah?.toJson(),
        'mzonagempaId': mzonagempaId,
        'comboMZonaGempa': comboMZonaGempa?.toJson(),
        'rkonstruksiojkId': rkonstruksiojkId,
        'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
        'rokupasiId': rokupasiId,
        'comboROkupasi': comboROkupasi?.toJson(),
        'currDesc': currDesc,
        'rmatauangKode': rmatauangKode,
        'comboRMatauang': comboRMatauang?.toJson()
      };
}
