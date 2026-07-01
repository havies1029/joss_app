import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';

class KlaimparklaimcrudModel {
  DateTime? dol;
  bool isPolisJps;
  String keterangan;
  String klaim1Id;
  DateTime? laporAsuransi;
  DateTime? laporJps;
  String penyebab;
  String picEmail;
  String picJabatan;
  String picNama;
  String picTelp;
  String? mjenisrugiId;
  ComboMJenisrugiModel? comboMJenisrugi;
  String cobId;
  String cobNama;

  // tambahan
  String? currId;
  ComboRMatauangModel? comboRMatauang;
  double klaimAmount;

  KlaimparklaimcrudModel({
    this.dol,
    this.isPolisJps = false,
    required this.keterangan,
    required this.klaim1Id,
    this.laporAsuransi,
    this.laporJps,
    required this.penyebab,
    required this.picEmail,
    required this.picJabatan,
    required this.picNama,
    required this.picTelp,
    this.mjenisrugiId,
    this.comboMJenisrugi,
    required this.cobId,
    required this.cobNama,
    this.currId,
    this.comboRMatauang,
    this.klaimAmount = 0,
  });

  factory KlaimparklaimcrudModel.fromJson(Map<String, dynamic> data) {
    ComboMJenisrugiModel? comboMJenisrugi;
    if (data['comboMJenisrugi'] != null) {
      comboMJenisrugi = ComboMJenisrugiModel.fromJson(data['comboMJenisrugi']);
    }

    ComboRMatauangModel? comboRMatauang;
    if (data['comboRMatauang'] != null) {
      comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
    }

    return KlaimparklaimcrudModel(
      dol: _parseNullableDate(data['dol']),
      isPolisJps: data['isPolisJps'] ?? false,
      keterangan: data['keterangan'] ?? '',
      klaim1Id: data['klaim1Id'] ?? '',
      laporAsuransi: _parseNullableDate(data['laporAsuransi']),
      laporJps: _parseNullableDate(data['laporJps']),
      penyebab: data['penyebab'] ?? '',
      picEmail: data['picEmail'] ?? '',
      picJabatan: data['picJabatan'] ?? '',
      picNama: data['picNama'] ?? '',
      picTelp: data['picTelp'] ?? '',
      mjenisrugiId: data['mjenisrugiId'] ?? '',
      comboMJenisrugi: comboMJenisrugi,
      cobId: data['cobId'] ?? '',
      cobNama: data['cobNama'] ?? '',
      currId: data['currId'] ?? '',
      comboRMatauang: comboRMatauang,
      klaimAmount: double.tryParse(data['klaimAmount'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'dol': dol?.toIso8601String(),
        'isPolisJps': isPolisJps,
        'keterangan': keterangan,
        'klaim1Id': klaim1Id,
        'laporAsuransi': laporAsuransi?.toIso8601String(),
        'laporJps': laporJps?.toIso8601String(),
        'penyebab': penyebab,
        'picEmail': picEmail,
        'picJabatan': picJabatan,
        'picNama': picNama,
        'picTelp': picTelp,
        'mjenisrugiId': mjenisrugiId,
        'comboMJenisrugi': comboMJenisrugi?.toJson(),
        'cobId': cobId,
        'cobNama': cobNama,
        'currId': currId,
        'comboRMatauang': comboRMatauang?.toJson(),
        'klaimAmount': klaimAmount,
      };

  KlaimparklaimcrudModel copyWith({
    Object? dol = _unset,
    bool? isPolisJps,
    String? keterangan,
    String? klaim1Id,
    Object? laporAsuransi = _unset,
    Object? laporJps = _unset,
    String? penyebab,
    String? picEmail,
    String? picJabatan,
    String? picNama,
    String? picTelp,
    String? mjenisrugiId,
    ComboMJenisrugiModel? comboMJenisrugi,
    String? cobId,
    String? cobNama,
    String? currId,
    ComboRMatauangModel? comboRMatauang,
    double? klaimAmount,
  }) {
    return KlaimparklaimcrudModel(
      dol: identical(dol, _unset) ? this.dol : dol as DateTime?,
      isPolisJps: isPolisJps ?? this.isPolisJps,
      keterangan: keterangan ?? this.keterangan,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      laporAsuransi: identical(laporAsuransi, _unset)
          ? this.laporAsuransi
          : laporAsuransi as DateTime?,
      laporJps:
          identical(laporJps, _unset) ? this.laporJps : laporJps as DateTime?,
      penyebab: penyebab ?? this.penyebab,
      picEmail: picEmail ?? this.picEmail,
      picJabatan: picJabatan ?? this.picJabatan,
      picNama: picNama ?? this.picNama,
      picTelp: picTelp ?? this.picTelp,
      mjenisrugiId: mjenisrugiId ?? this.mjenisrugiId,
      comboMJenisrugi: comboMJenisrugi ?? this.comboMJenisrugi,
      cobId: cobId ?? this.cobId,
      cobNama: cobNama ?? this.cobNama,
      currId: currId ?? this.currId,
      comboRMatauang: comboRMatauang ?? this.comboRMatauang,
      klaimAmount: klaimAmount ?? this.klaimAmount,
    );
  }
}

const Object _unset = Object();

DateTime? _parseNullableDate(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;

  return DateTime.tryParse(text);
}
