import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';

class KlaimmvpoliscrudModel {
  String insuredNama;
  bool isPolisJps;
  String klaim1Id;
  DateTime? laporAsuransi;
  String noChasis;
  String noPlat;
  DateTime? polisAkhir;
  DateTime? polisMulai;
  String polisNo;
  String sppa1Id;
  String? minsurerId;
  ComboMInsurerModel? comboMInsurer;
  String? mmvjnscoverId;
  ComboMMvjnscoverModel? comboMMvjnscover;

  KlaimmvpoliscrudModel(
      {required this.insuredNama,
      required this.isPolisJps,
      required this.klaim1Id,
      this.laporAsuransi,
      required this.noChasis,
      required this.noPlat,
      this.polisAkhir,
      this.polisMulai,
      required this.polisNo,
      required this.sppa1Id,
      this.minsurerId,
      this.comboMInsurer,
      this.mmvjnscoverId,
      this.comboMMvjnscover});

  factory KlaimmvpoliscrudModel.fromJson(Map<String, dynamic> data) {
    ComboMInsurerModel? comboMInsurer;
    if (data['comboMInsurer'] != null) {
      comboMInsurer = ComboMInsurerModel.fromJson(data['comboMInsurer']);
    }

    ComboMMvjnscoverModel? comboMMvjnscover;
    if (data['comboMMvjnscover'] != null) {
      comboMMvjnscover =
          ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
    }

    return KlaimmvpoliscrudModel(
        insuredNama: data['insuredNama'] ?? '',
        isPolisJps: data['isPolisJps'] == true,
        klaim1Id: data['klaim1Id'] ?? '',
        laporAsuransi:
            DateTime.tryParse(data['laporAsuransi']?.toString() ?? ''),
        noChasis: data['noChasis'] ?? '',
        noPlat: data['noPlat'] ?? '',
        polisAkhir: DateTime.tryParse(data['polisAkhir']?.toString() ?? ''),
        polisMulai: DateTime.tryParse(data['polisMulai']?.toString() ?? ''),
        polisNo: data['polisNo'] ?? '',
        sppa1Id: data['sppa1Id'] ?? '',
        minsurerId: data['minsurerId'] ?? '',
        comboMInsurer: comboMInsurer,
        mmvjnscoverId: data['mmvjnscoverId'] ?? '',
        comboMMvjnscover: comboMMvjnscover);
  }

  Map<String, dynamic> toJson() => {
        'insuredNama': insuredNama,
        'isPolisJps': isPolisJps,
        'klaim1Id': klaim1Id,
        'laporAsuransi': laporAsuransi?.toIso8601String(),
        'noChasis': noChasis,
        'noPlat': noPlat,
        'polisAkhir': polisAkhir?.toIso8601String(),
        'polisMulai': polisMulai?.toIso8601String(),
        'polisNo': polisNo,
        'sppa1Id': sppa1Id,
        'minsurerId': minsurerId,
        'comboMInsurer': comboMInsurer?.toJson(),
        'mmvjnscoverId': mmvjnscoverId,
        'comboMMvjnscover': comboMMvjnscover?.toJson()
      };

  KlaimmvpoliscrudModel copyWith({
    String? insuredNama,
    bool? isPolisJps,
    String? klaim1Id,
    DateTime? laporAsuransi,
    String? noChasis,
    String? noPlat,
    DateTime? polisAkhir,
    DateTime? polisMulai,
    String? polisNo,
    String? sppa1Id,
    String? minsurerId,
    ComboMInsurerModel? comboMInsurer,
    String? mmvjnscoverId,
    ComboMMvjnscoverModel? comboMMvjnscover,
  }) {
    return KlaimmvpoliscrudModel(
      insuredNama: insuredNama ?? this.insuredNama,
      isPolisJps: isPolisJps ?? this.isPolisJps,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      laporAsuransi: laporAsuransi ?? this.laporAsuransi,
      noChasis: noChasis ?? this.noChasis,
      noPlat: noPlat ?? this.noPlat,
      polisAkhir: polisAkhir ?? this.polisAkhir,
      polisMulai: polisMulai ?? this.polisMulai,
      polisNo: polisNo ?? this.polisNo,
      sppa1Id: sppa1Id ?? this.sppa1Id,
      minsurerId: minsurerId ?? this.minsurerId,
      comboMInsurer: comboMInsurer ?? this.comboMInsurer,
      mmvjnscoverId: mmvjnscoverId ?? this.mmvjnscoverId,
      comboMMvjnscover: comboMMvjnscover ?? this.comboMMvjnscover,
    );
  }
}
