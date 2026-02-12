import 'package:joss_app/models/klaimrasio/klaimrasiocobcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiograndcurrcari_model.dart';

class KlaimrasiocariModel {
  final List<KlaimrasiocobCariModel> cobs;
  final List<KlaimrasiograndcurrCariModel> grandcurrs;  

  KlaimrasiocariModel({required this.cobs, required this.grandcurrs});

  factory KlaimrasiocariModel.fromJson(Map<String, dynamic> json) {
    return KlaimrasiocariModel(
      cobs: (json['cobs'] as List<dynamic>? ?? [])
          .map((e) => KlaimrasiocobCariModel.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList(),
      grandcurrs: (json['grandcurrs'] as List<dynamic>? ?? [])
          .map((e) => KlaimrasiograndcurrCariModel.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'cobs': cobs.map((d) => d.toJson()).toList(),
    'grandcurrs': grandcurrs.map((g) => g.toJson()).toList(),
  };
}

