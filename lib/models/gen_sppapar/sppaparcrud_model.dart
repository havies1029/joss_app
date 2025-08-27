import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomtarifojkbanjirpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class SppaparCrudModel {
  String buildingDesc;
  String contentDesc;
  String insuredAlamat1;
  String insuredAlamat2;
  String insuredNama;
  String lokasi1;
  String lokasi2;
  String machineryDesc;
  String otherDesc;
  DateTime periodeAkhir;
  DateTime periodeMulai;
  double premiEqvet;
  double premiOther;
  double premiPar;
  double premiRsmdcc;
  double premiTotal;
  double premiTsfwd;
  double rateEqvet;
  double rateOther;
  double ratePar;
  double rateRsmdcc;
  double rateTotal;
  double rateTsfwd;
  double siBuilding;
  double siContent;
  double siMachinery;
  double siOther;
  double siStock;
  DateTime sppaTgl;
  String sppa1Id;
  double stockAdjustable;
  String stockDesc;
  double tsi;
  String? curr;
  String? kab2zonagempaId;
  ComboMKabZonaGempaModel? comboMKabZonaGempa;
  String? mwilayahId;
  ComboMWilayahModel? comboMWilayah;
  String? rkodeposId;
  ComboRKodeposModel? comboRKodepos;
  String? rkonstruksiojkId;
  ComboRKonstruksiojkModel? comboRKonstruksiojk;
  String? rokupasiId;
  ComboROkupasiModel? comboROkupasi;

  SppaparCrudModel(
      {required this.buildingDesc,
      required this.contentDesc,
      required this.insuredAlamat1,
      required this.insuredAlamat2,
      required this.insuredNama,
      required this.lokasi1,
      required this.lokasi2,
      required this.machineryDesc,
      required this.otherDesc,
      required this.periodeAkhir,
      required this.periodeMulai,
      required this.premiEqvet,
      required this.premiOther,
      required this.premiPar,
      required this.premiRsmdcc,
      required this.premiTotal,
      required this.premiTsfwd,
      required this.rateEqvet,
      required this.rateOther,
      required this.ratePar,
      required this.rateRsmdcc,
      required this.rateTotal,
      required this.rateTsfwd,
      required this.siBuilding,
      required this.siContent,
      required this.siMachinery,
      required this.siOther,
      required this.siStock,
      required this.sppaTgl,
      required this.sppa1Id,
      required this.stockAdjustable,
      required this.stockDesc,
      required this.tsi,
      this.curr,
      this.kab2zonagempaId,
      this.comboMKabZonaGempa,
      this.mwilayahId,
      this.comboMWilayah,
      this.rkodeposId,
      this.comboRKodepos,
      this.rkonstruksiojkId,
      this.comboRKonstruksiojk,
      this.rokupasiId,
      this.comboROkupasi});

  factory SppaparCrudModel.fromJson(Map<String, dynamic> data) {
    ComboMKabZonaGempaModel? comboMKabZonaGempa;
    if (data['comboMKabZonaGempa'] != null) {
      comboMKabZonaGempa =
          ComboMKabZonaGempaModel.fromJson(data['comboMKabZonaGempa']);
    }

    ComboMTarifojkBanjirParModel? comboMTarifojkBanjirPar;
    if (data['comboMTarifojkBanjirPar'] != null) {
      comboMTarifojkBanjirPar = ComboMTarifojkBanjirParModel.fromJson(
          data['comboMTarifojkBanjirPar']);
    }

    ComboMWilayahModel? comboMWilayah;
    if (data['comboMWilayah'] != null) {
      comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
    }

    ComboRKodeposModel? comboRKodepos;
    if (data['comboRKodepos'] != null) {
      comboRKodepos = ComboRKodeposModel.fromJson(data['comboRKodepos']);
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

    return SppaparCrudModel(       
        buildingDesc: data['buildingDesc'] ?? '',
        contentDesc: data['contentDesc'] ?? '',        
        insuredAlamat1: data['insuredAlamat1'] ?? '',
        insuredAlamat2: data['insuredAlamat2'] ?? '',
        insuredNama: data['insuredNama'] ?? '',
        lokasi1: data['lokasi1'] ?? '',
        lokasi2: data['lokasi2'] ?? '',
        machineryDesc: data['machineryDesc'] ?? '',
        otherDesc: data['otherDesc'] ?? '',
        periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString()) ??
            DateTime.now(),
        periodeMulai: DateTime.tryParse(data['periodeMulai'].toString()) ??
            DateTime.now(),
        premiEqvet: double.tryParse(data['premiEqvet'].toString()) ?? 0,
        premiOther: double.tryParse(data['premiOther'].toString()) ?? 0,
        premiPar: double.tryParse(data['premiPar'].toString()) ?? 0,
        premiRsmdcc: double.tryParse(data['premiRsmdcc'].toString()) ?? 0,
        premiTotal: double.tryParse(data['premiTotal'].toString()) ?? 0,
        premiTsfwd: double.tryParse(data['premiTsfwd'].toString()) ?? 0,
        rateEqvet: double.tryParse(data['rateEqvet'].toString()) ?? 0,
        rateOther: double.tryParse(data['rateOther'].toString()) ?? 0,
        ratePar: double.tryParse(data['ratePar'].toString()) ?? 0,
        rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString()) ?? 0,
        rateTotal: double.tryParse(data['rateTotal'].toString()) ?? 0,
        rateTsfwd: double.tryParse(data['rateTsfwd'].toString()) ?? 0,
        siBuilding: double.tryParse(data['siBuilding'].toString()) ?? 0,
        siContent: double.tryParse(data['siContent'].toString()) ?? 0,
        siMachinery: double.tryParse(data['siMachinery'].toString()) ?? 0,
        siOther: double.tryParse(data['siOther'].toString()) ?? 0,
        siStock: double.tryParse(data['siStock'].toString()) ?? 0,
        sppaTgl:
            DateTime.tryParse(data['sppaTgl'].toString()) ?? DateTime.now(),
        sppa1Id: data['sppa1Id'] ?? '',
        stockAdjustable:
            double.tryParse(data['stockAdjustable'].toString()) ?? 0,
        stockDesc: data['stockDesc'] ?? '',
        tsi: double.tryParse(data['tsi'].toString()) ?? 0,
        curr: data['curr'] ?? '',
        kab2zonagempaId: data['kab2zonagempaId'] ?? '',
        comboMKabZonaGempa: comboMKabZonaGempa,
        mwilayahId: data['mwilayahId'] ?? '',
        comboMWilayah: comboMWilayah,
        rkodeposId: data['rkodeposId'] ?? '',
        comboRKodepos: comboRKodepos,
        rkonstruksiojkId: data['rkonstruksiojkId'] ?? '',
        comboRKonstruksiojk: comboRKonstruksiojk,
        rokupasiId: data['rokupasiId'] ?? '',
        comboROkupasi: comboROkupasi);
  }

  Map<String, dynamic> toJson() => {       
        'buildingDesc': buildingDesc,
        'contentDesc': contentDesc,        
        'insuredAlamat1': insuredAlamat1,
        'insuredAlamat2': insuredAlamat2,
        'insuredNama': insuredNama,
        'lokasi1': lokasi1,
        'lokasi2': lokasi2,
        'machineryDesc': machineryDesc,        
        'otherDesc': otherDesc,
        'periodeAkhir': periodeAkhir.toIso8601String(),
        'periodeMulai': periodeMulai.toIso8601String(),
        'premiEqvet': premiEqvet.toString(),
        'premiOther': premiOther.toString(),
        'premiPar': premiPar.toString(),
        'premiRsmdcc': premiRsmdcc.toString(),
        'premiTotal': premiTotal.toString(),
        'premiTsfwd': premiTsfwd.toString(),
        'rateEqvet': rateEqvet.toString(),
        'rateOther': rateOther.toString(),
        'ratePar': ratePar.toString(),
        'rateRsmdcc': rateRsmdcc.toString(),
        'rateTotal': rateTotal.toString(),
        'rateTsfwd': rateTsfwd.toString(),
        'siBuilding': siBuilding.toString(),
        'siContent': siContent.toString(),
        'siMachinery': siMachinery.toString(),
        'siOther': siOther.toString(),
        'siStock': siStock.toString(),
        'sppaTgl': sppaTgl.toIso8601String(),
        'sppa1Id': sppa1Id,
        'stockAdjustable': stockAdjustable.toString(),
        'stockDesc': stockDesc,
        'tsi': tsi.toString(),
        'curr': curr,
        'kab2zonagempaId': kab2zonagempaId,
        'comboMKabZonaGempa': comboMKabZonaGempa?.toJson(),
        'mwilayahId': mwilayahId,
        'comboMWilayah': comboMWilayah?.toJson(),
        'rkodeposId': rkodeposId,
        'comboRKodepos': comboRKodepos?.toJson(),
        'rkonstruksiojkId': rkonstruksiojkId,
        'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
        'rokupasiId': rokupasiId,
        'comboROkupasi': comboROkupasi?.toJson()
      };
}
