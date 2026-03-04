import 'package:joss_app/models/combobox/combomjnskel_model.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';

class MRekanGeneralIdvCrudModel {
  String? mjnskelId;
  String mrekan1Id;
  String rekanNama;
  String? mpekerjaanId;
  ComboMPekerjaanModel? comboMPekerjaan;
  ComboMJnskelModel? comboMJnskel;

  MRekanGeneralIdvCrudModel(
      {required this.mjnskelId,
        required this.mrekan1Id,
        required this.rekanNama,
        this.mpekerjaanId,
        this.comboMPekerjaan,
        this.comboMJnskel});

  factory MRekanGeneralIdvCrudModel.fromJson(Map<String, dynamic> data) {
    ComboMPekerjaanModel? comboMPekerjaan;
    if (data['comboMPekerjaan'] != null) {
      comboMPekerjaan = ComboMPekerjaanModel.fromJson(data['comboMPekerjaan']);
    }

    ComboMJnskelModel? comboMJnskel;
    if (data['comboMJnskel'] != null) {
      comboMJnskel = ComboMJnskelModel.fromJson(data['comboMJnskel']);
    }

    return MRekanGeneralIdvCrudModel(
        mjnskelId: data['mjnskelId'] ?? '',
        mrekan1Id: data['mrekan1Id'] ?? '',
        rekanNama: data['rekanNama'] ?? '',
        mpekerjaanId: data['mpekerjaanId'] ?? '',
        comboMPekerjaan: comboMPekerjaan,
        comboMJnskel: comboMJnskel);
  }

  Map<String, dynamic> toJson() => {
    'mjnskelId': mjnskelId,
    'mrekan1Id': mrekan1Id,
    'rekanNama': rekanNama,
    'mpekerjaanId': mpekerjaanId,
    'comboMPekerjaan': comboMPekerjaan?.toJson(),
    'comboMJnsKel': comboMJnskel?.toJson()
  };
}
