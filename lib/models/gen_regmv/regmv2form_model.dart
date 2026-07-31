import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';

class Regmv2FormModel {
  bool isAw;
  bool isEq;
  bool isFlood;
  bool isSrcc;
  bool isTbod;
  bool isTerrorism;
  double pad;
  double pap;
  int passangerCount;
  double pll;
  DateTime polisAkhir;
  DateTime polisMulai;
  String regmv2Id;
  String regmv1Id;
  double tpl;
  String? currId;
  ComboRMatauangModel? comboRMatauang;
  String? mmvjnscoverId;
  ComboMMvjnscoverModel? comboMMvjnscover;

  Regmv2FormModel({
    required this.isAw,
    required this.isEq,
    required this.isFlood,
    required this.isSrcc,
    required this.isTbod,
    required this.isTerrorism,
    required this.pad,
    required this.pap,
    required this.passangerCount,
    required this.pll,
    required this.polisAkhir,
    required this.polisMulai,
    required this.regmv2Id,
    required this.regmv1Id,
    required this.tpl,
    this.currId,
    this.comboRMatauang,
    this.mmvjnscoverId,
    this.comboMMvjnscover,
  });

  factory Regmv2FormModel.fromJson(Map<String, dynamic> data) {
    ComboRMatauangModel? comboRMatauang;
    if (data['comboRMatauang'] != null) {
      comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
    } else if ((data['currId'] ?? '').toString().trim().isNotEmpty ||
        (data['rMATAUANGNAMA'] ?? '').toString().trim().isNotEmpty) {
      comboRMatauang = ComboRMatauangModel(
        rmatauangKode: data['currId']?.toString() ?? '',
        rmatauangNama: data['rMATAUANGNAMA']?.toString() ?? '',
        rmatauangSimbol: data['currId']?.toString() ?? '',
      );
    }

    ComboMMvjnscoverModel? comboMMvjnscover;
    if (data['comboMMvjnscover'] != null) {
      comboMMvjnscover =
          ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
    } else if ((data['mmvjnscoverId'] ?? '').toString().trim().isNotEmpty ||
        (data['coverName'] ?? '').toString().trim().isNotEmpty) {
      comboMMvjnscover = ComboMMvjnscoverModel(
        mmvjnscoverId: data['mmvjnscoverId']?.toString() ?? '',
        coverName: data['coverName']?.toString() ?? '',
      );
    }

    return Regmv2FormModel(
      isAw: data['isAw'] ?? false,
      isEq: data['isEq'] ?? false,
      isFlood: data['isFlood'] ?? false,
      isSrcc: data['isSrcc'] ?? false,
      isTbod: data['isTbod'] ?? false,
      isTerrorism: data['isTerrorism'] ?? false,
      pad: double.tryParse(data['pad'].toString()) ?? 0,
      pap: double.tryParse(data['pap'].toString()) ?? 0,
      passangerCount: int.tryParse(data['passangerCount'].toString()) ?? 0,
      pll: double.tryParse(data['pll'].toString()) ?? 0,
      polisAkhir:
          DateTime.tryParse(data['polisAkhir'].toString()) ?? DateTime.now(),
      polisMulai:
          DateTime.tryParse(data['polisMulai'].toString()) ?? DateTime.now(),
      regmv2Id: data['regmv2Id'] ?? '',
      regmv1Id: data['regmv1Id'] ?? '',
      tpl: double.tryParse(data['tpl'].toString()) ?? 0,
      currId: data['currId'],
      comboRMatauang: comboRMatauang,
      mmvjnscoverId: data['mmvjnscoverId'],
      comboMMvjnscover: comboMMvjnscover,
    );
  }

  Map<String, dynamic> toJson() => {
        'isAw': isAw,
        'isEq': isEq,
        'isFlood': isFlood,
        'isSrcc': isSrcc,
        'isTbod': isTbod,
        'isTerrorism': isTerrorism,
        'pad': pad.toString(),
        'pap': pap.toString(),
        'passangerCount': passangerCount.toString(),
        'pll': pll.toString(),
        'polisAkhir': polisAkhir.toIso8601String(),
        'polisMulai': polisMulai.toIso8601String(),
        'regmv2Id': regmv2Id,
        'regmv1Id': regmv1Id,
        'tpl': tpl.toString(),
        'currId': currId,
        'comboRMatauang': comboRMatauang?.toJson(),
        'mmvjnscoverId': mmvjnscoverId,
        'comboMMvjnscover': comboMMvjnscover?.toJson(),
      };

  Regmv2FormModel copyWith({
    bool? isAw,
    bool? isEq,
    bool? isFlood,
    bool? isSrcc,
    bool? isTbod,
    bool? isTerrorism,
    double? pad,
    double? pap,
    int? passangerCount,
    double? pll,
    DateTime? polisAkhir,
    DateTime? polisMulai,
    String? regmv2Id,
    String? regmv1Id,
    double? tpl,
    String? currId,
    ComboRMatauangModel? comboRMatauang,
    String? mmvjnscoverId,
    ComboMMvjnscoverModel? comboMMvjnscover,
  }) {
    return Regmv2FormModel(
      isAw: isAw ?? this.isAw,
      isEq: isEq ?? this.isEq,
      isFlood: isFlood ?? this.isFlood,
      isSrcc: isSrcc ?? this.isSrcc,
      isTbod: isTbod ?? this.isTbod,
      isTerrorism: isTerrorism ?? this.isTerrorism,
      pad: pad ?? this.pad,
      pap: pap ?? this.pap,
      passangerCount: passangerCount ?? this.passangerCount,
      pll: pll ?? this.pll,
      polisAkhir: polisAkhir ?? this.polisAkhir,
      polisMulai: polisMulai ?? this.polisMulai,
      regmv2Id: regmv2Id ?? this.regmv2Id,
      regmv1Id: regmv1Id ?? this.regmv1Id,
      tpl: tpl ?? this.tpl,
      currId: currId ?? this.currId,
      comboRMatauang: comboRMatauang ?? this.comboRMatauang,
      mmvjnscoverId: mmvjnscoverId ?? this.mmvjnscoverId,
      comboMMvjnscover: comboMMvjnscover ?? this.comboMMvjnscover,
    );
  }
}
