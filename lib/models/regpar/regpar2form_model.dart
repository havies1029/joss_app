import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/combomkecamatan_model.dart';
import 'package:joss_app/models/combobox/combomkelurahan_model.dart';

class Regpar2FormModel {
	String regpar1Id;
	String? objectAlamat;
	DateTime polisAkhir;
	DateTime polisMulai;
	String regpar2Id;

	String? objectKecamatanId;
	ComboMKecamatanModel? comboMKecamatan;

	String? objectKelurahanId;
	ComboMKelurahanModel? comboMKelurahan;

	String? objectKotaId;
	ComboMKotaModel? comboMKota;

	String? objectPropinsiId;
	ComboMPropinsiModel? comboMPropinsi;

	String? rkonstruksiojkId;
	ComboRKonstruksiojkModel? comboRKonstruksiojk;

	String? rokupasiId;
	ComboROkupasiModel? comboROkupasi;

	Regpar2FormModel({
		required this.regpar1Id,
		required this.objectAlamat,
		required this.polisAkhir,
		required this.polisMulai,
		required this.regpar2Id,
		this.objectKecamatanId,
		this.comboMKecamatan,
		this.objectKelurahanId,
		this.comboMKelurahan,
		this.objectKotaId,
		this.comboMKota,
		this.objectPropinsiId,
		this.comboMPropinsi,
		this.rkonstruksiojkId,
		this.comboRKonstruksiojk,
		this.rokupasiId,
		this.comboROkupasi,
	});

	factory Regpar2FormModel.fromJson(Map<String, dynamic> data) {
		return Regpar2FormModel(
			regpar1Id: data['regpar1Id'] ?? '',
			objectAlamat: data['objectAlamat'] ?? '',
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString()) ?? DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString()) ?? DateTime.now(),
			regpar2Id: data['regpar2Id'] ?? '',

			objectKecamatanId: data['objectKecamatanId'],
			comboMKecamatan: data['comboMKecamatan'] != null
					? ComboMKecamatanModel.fromJson(data['comboMKecamatan'])
					: null,

			objectKelurahanId: data['objectKelurahanId'],
			comboMKelurahan: data['comboMKelurahan'] != null
					? ComboMKelurahanModel.fromJson(data['comboMKelurahan'])
					: null,

			objectKotaId: data['objectKotaId'],
			comboMKota: data['comboMKota'] != null
					? ComboMKotaModel.fromJson(data['comboMKota'])
					: null,

			objectPropinsiId: data['objectPropinsiId'],
			comboMPropinsi: data['comboMPropinsi'] != null
					? ComboMPropinsiModel.fromJson(data['comboMPropinsi'])
					: null,

			rkonstruksiojkId: data['rkonstruksiojkId'],
			comboRKonstruksiojk: data['comboRKonstruksiojk'] != null
					? ComboRKonstruksiojkModel.fromJson(data['comboRKonstruksiojk'])
					: null,

			rokupasiId: data['rokupasiId'],
			comboROkupasi: data['comboROkupasi'] != null
					? ComboROkupasiModel.fromJson(data['comboROkupasi'])
					: null,
		);
	}

	Map<String, dynamic> toJson() => {
		'regpar1Id': regpar1Id,
		'objectAlamat': objectAlamat,
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
		'regpar2Id': regpar2Id,
		'objectKecamatanId': objectKecamatanId,
		'comboMKecamatan': comboMKecamatan?.toJson(),
		'objectKelurahanId': objectKelurahanId,
		'comboMKelurahan': comboMKelurahan?.toJson(),
		'objectKotaId': objectKotaId,
		'comboMKota': comboMKota?.toJson(),
		'objectPropinsiId': objectPropinsiId,
		'comboMPropinsi': comboMPropinsi?.toJson(),
		'rkonstruksiojkId': rkonstruksiojkId,
		'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
		'rokupasiId': rokupasiId,
		'comboROkupasi': comboROkupasi?.toJson(),
	};

	Regpar2FormModel copyWith({
		String? regpar1Id,
		String? objectAlamat,
		DateTime? polisAkhir,
		DateTime? polisMulai,
		String? regpar2Id,
		String? objectKecamatanId,
		ComboMKecamatanModel? comboMKecamatan,
		String? objectKelurahanId,
		ComboMKelurahanModel? comboMKelurahan,
		String? objectKotaId,
		ComboMKotaModel? comboMKota,
		String? objectPropinsiId,
		ComboMPropinsiModel? comboMPropinsi,
		String? rkonstruksiojkId,
		ComboRKonstruksiojkModel? comboRKonstruksiojk,
		String? rokupasiId,
		ComboROkupasiModel? comboROkupasi,
	}) {
		return Regpar2FormModel(
			regpar1Id: regpar1Id ?? this.regpar1Id,
			objectAlamat: objectAlamat ?? this.objectAlamat,
			polisAkhir: polisAkhir ?? this.polisAkhir,
			polisMulai: polisMulai ?? this.polisMulai,
			regpar2Id: regpar2Id ?? this.regpar2Id,
			objectKecamatanId: objectKecamatanId ?? this.objectKecamatanId,
			comboMKecamatan: comboMKecamatan ?? this.comboMKecamatan,
			objectKelurahanId: objectKelurahanId ?? this.objectKelurahanId,
			comboMKelurahan: comboMKelurahan ?? this.comboMKelurahan,
			objectKotaId: objectKotaId ?? this.objectKotaId,
			comboMKota: comboMKota ?? this.comboMKota,
			objectPropinsiId: objectPropinsiId ?? this.objectPropinsiId,
			comboMPropinsi: comboMPropinsi ?? this.comboMPropinsi,
			rkonstruksiojkId: rkonstruksiojkId ?? this.rkonstruksiojkId,
			comboRKonstruksiojk:
			comboRKonstruksiojk ?? this.comboRKonstruksiojk,
			rokupasiId: rokupasiId ?? this.rokupasiId,
			comboROkupasi: comboROkupasi ?? this.comboROkupasi,
		);
	}
}
