import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';

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

	// tambahan
	String? currId;
	ComboRMatauangModel? comboRMatauang;
	double klaimAmount;

	KlaimparklaimcrudModel({
		required this.dol,
		this.isPolisJps = false,
		required this.keterangan,
		required this.klaim1Id,
		required this.laporAsuransi,
		required this.laporJps,
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
			dol: DateTime.tryParse(data['dol'].toString()) ?? DateTime.now(),
			isPolisJps: data['isPolisJps'] ?? false,
			keterangan: data['keterangan'] ?? '',
			klaim1Id: data['klaim1Id'] ?? '',
			laporAsuransi:
			DateTime.tryParse(data['laporAsuransi'].toString()) ?? DateTime.now(),
			laporJps:
			DateTime.tryParse(data['laporJps'].toString()) ?? DateTime.now(),
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
		'dol': dol.toIso8601String(),
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
		'currId': currId,
		'comboRMatauang': comboRMatauang?.toJson(),
		'klaimAmount': klaimAmount,
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
		String? currId,
		ComboRMatauangModel? comboRMatauang,
		double? klaimAmount,
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
			currId: currId ?? this.currId,
			comboRMatauang: comboRMatauang ?? this.comboRMatauang,
			klaimAmount: klaimAmount ?? this.klaimAmount,
		);
	}
}