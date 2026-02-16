import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';

class KlaimparklaimcrudModel {
	DateTime dol;
	bool isPolisJps;
	String keterangan;
	String klaim1Id;
	DateTime laporAsuransi;
	DateTime laporJps;
	String penyebab;
	String picEmail;
	String picJabatan;
	String picNama;
	String picTelp;
	String? mjenisrugiId;
	ComboMJenisrugiModel? comboMJenisrugi;
  String cobId;
  String cobNama;

	KlaimparklaimcrudModel({required this.dol, this.isPolisJps = false, 
		required this.keterangan, required this.klaim1Id, 
		required this.laporAsuransi, required this.laporJps, 
		required this.penyebab, required this.picEmail, 
		required this.picJabatan, required this.picNama, 
		required this.picTelp, this.mjenisrugiId, this.comboMJenisrugi,
    required this.cobId,
    required this.cobNama,
  });

	factory KlaimparklaimcrudModel.fromJson(Map<String, dynamic> data) {
		ComboMJenisrugiModel? comboMJenisrugi;
		if (data['comboMJenisrugi'] != null) {
			comboMJenisrugi = ComboMJenisrugiModel.fromJson(data['comboMJenisrugi']);
		}

		return KlaimparklaimcrudModel(
			dol: DateTime.tryParse(data['dol'].toString())??DateTime.now(),
			isPolisJps: data['isPolisJps']??false,
			keterangan: data['keterangan']??'',
			klaim1Id: data['klaim1Id']??'',
			laporAsuransi: DateTime.tryParse(data['laporAsuransi'].toString())??DateTime.now(),
			laporJps: DateTime.tryParse(data['laporJps'].toString())??DateTime.now(),
			penyebab: data['penyebab']??'',
			picEmail: data['picEmail']??'',
			picJabatan: data['picJabatan']??'',
			picNama: data['picNama']??'',
			picTelp: data['picTelp']??'',
			mjenisrugiId: data['mjenisrugiId']??'',
			comboMJenisrugi: comboMJenisrugi,
      cobId: data['cobId']??'',
      cobNama: data['cobNama']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{'dol': dol.toIso8601String(),
		'isPolisJps': isPolisJps,
		'keterangan': keterangan,
		'klaim1Id': klaim1Id,
		'laporAsuransi': laporAsuransi.toIso8601String(),
		'laporJps': laporJps.toIso8601String(),
		'penyebab': penyebab,
		'picEmail': picEmail,
		'picJabatan': picJabatan,
		'picNama': picNama,
		'picTelp': picTelp,
		'mjenisrugiId': mjenisrugiId,
		'comboMJenisrugi': comboMJenisrugi?.toJson(),
    'cobId': cobId,
    'cobNama': cobNama,
    };

  KlaimparklaimcrudModel copyWith({
    DateTime? dol,
    bool? isPolisJps,
    String? keterangan,
    String? klaim1Id,
    DateTime? laporAsuransi,
    DateTime? laporJps,
    String? penyebab,
    String? picEmail,
    String? picJabatan,
    String? picNama,
    String? picTelp,
    String? mjenisrugiId,
    ComboMJenisrugiModel? comboMJenisrugi,
    String? cobId,
    String? cobNama,
  }) {
    return KlaimparklaimcrudModel(
      dol: dol ?? this.dol,
      isPolisJps: isPolisJps ?? this.isPolisJps,
      keterangan: keterangan ?? this.keterangan,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      laporAsuransi: laporAsuransi ?? this.laporAsuransi,
      laporJps: laporJps ?? this.laporJps,
      penyebab: penyebab ?? this.penyebab,
      picEmail: picEmail ?? this.picEmail,
      picJabatan: picJabatan ?? this.picJabatan,
      picNama: picNama ?? this.picNama,
      picTelp: picTelp ?? this.picTelp,
      mjenisrugiId: mjenisrugiId ?? this.mjenisrugiId,
      comboMJenisrugi: comboMJenisrugi ?? this.comboMJenisrugi,
      cobId: cobId ?? this.cobId,
      cobNama: cobNama ?? this.cobNama,
    );
  }
}
