import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';

class KlaimmvbengkelcrudModel {
  String klaim1Id;
  String namaBengkelLain;
  String? mbengkelId;
  ComboMBengkelModel? comboMBengkel;
  String? mjnsbengkelId;
  ComboMJnsbengkelModel? comboMJnsbengkel;
  String? mwilayahbengkelId;
  ComboMWilayahBengkelModel? comboMWilayahBengkel;

  KlaimmvbengkelcrudModel(
      {required this.klaim1Id,
      required this.namaBengkelLain,
      this.mbengkelId,
      this.comboMBengkel,
      this.mjnsbengkelId,
      this.comboMJnsbengkel,
      this.mwilayahbengkelId,
      this.comboMWilayahBengkel});

  factory KlaimmvbengkelcrudModel.fromJson(Map<String, dynamic> data) {
    ComboMBengkelModel? comboMBengkel;
    if (data['comboMBengkel'] != null) {
      comboMBengkel = ComboMBengkelModel.fromJson(data['comboMBengkel']);
    }

    ComboMJnsbengkelModel? comboMJnsbengkel;
    if (data['comboMJnsbengkel'] != null) {
      comboMJnsbengkel =
          ComboMJnsbengkelModel.fromJson(data['comboMJnsbengkel']);
    }

    ComboMWilayahBengkelModel? comboMWilayahBengkel;
    if (data['comboMWilayahBengkel'] != null) {
      comboMWilayahBengkel =
          ComboMWilayahBengkelModel.fromJson(data['comboMWilayahBengkel']);
    }

    return KlaimmvbengkelcrudModel(
        klaim1Id: data['klaim1Id'] ?? '',
        namaBengkelLain: data['namaBengkelLain'] ?? '',
        mbengkelId: data['mbengkelId'] ?? '',
        comboMBengkel: comboMBengkel,
        mjnsbengkelId: data['mjnsbengkelId'] ?? '',
        comboMJnsbengkel: comboMJnsbengkel,
        mwilayahbengkelId: data['mwilayahbengkelId'] ?? '',
        comboMWilayahBengkel: comboMWilayahBengkel);
  }

  Map<String, dynamic> toJson() => {
        'klaim1Id': klaim1Id,
        'namaBengkelLain': namaBengkelLain,
        'mbengkelId': mbengkelId,
        'comboMBengkel': comboMBengkel?.toJson(),
        'mjnsbengkelId': mjnsbengkelId,
        'comboMJnsbengkel': comboMJnsbengkel?.toJson(),
        'mwilayahbengkelId': mwilayahbengkelId,
        'comboMWilayahBengkel': comboMWilayahBengkel?.toJson()
      };
  static const _sentinel = Object();

  KlaimmvbengkelcrudModel copyWith({
    String? klaim1Id,
    String? namaBengkelLain,
    Object? mbengkelId = _sentinel,
    Object? comboMBengkel = _sentinel,
    Object? mjnsbengkelId = _sentinel,
    Object? comboMJnsbengkel = _sentinel,
    Object? mwilayahbengkelId = _sentinel,
    Object? comboMWilayahBengkel = _sentinel,
  }) {
    return KlaimmvbengkelcrudModel(
      klaim1Id: klaim1Id ?? this.klaim1Id,
      namaBengkelLain: namaBengkelLain ?? this.namaBengkelLain,
      mbengkelId: identical(mbengkelId, _sentinel)
          ? this.mbengkelId
          : mbengkelId as String?,
      comboMBengkel: identical(comboMBengkel, _sentinel)
          ? this.comboMBengkel
          : comboMBengkel as ComboMBengkelModel?,
      mjnsbengkelId: identical(mjnsbengkelId, _sentinel)
          ? this.mjnsbengkelId
          : mjnsbengkelId as String?,
      comboMJnsbengkel: identical(comboMJnsbengkel, _sentinel)
          ? this.comboMJnsbengkel
          : comboMJnsbengkel as ComboMJnsbengkelModel?,
      mwilayahbengkelId: identical(mwilayahbengkelId, _sentinel)
          ? this.mwilayahbengkelId
          : mwilayahbengkelId as String?,
      comboMWilayahBengkel: identical(comboMWilayahBengkel, _sentinel)
          ? this.comboMWilayahBengkel
          : comboMWilayahBengkel as ComboMWilayahBengkelModel?,
    );
  }

  factory KlaimmvbengkelcrudModel.empty() {
    return KlaimmvbengkelcrudModel(
      klaim1Id: '',
      namaBengkelLain: '',
      mbengkelId: null,
      comboMBengkel: null,
      mjnsbengkelId: null,
      comboMJnsbengkel: null,
      mwilayahbengkelId: null,
      comboMWilayahBengkel: null,
    );
  }
}
