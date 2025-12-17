import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class Regpar3FormModel {
	String regpar1Id;
	bool? isEq;
	bool? isFlexas;
	bool? isOther;
	bool? isRsmdcc;
	bool? isTsfwd;
	String regpar3Id;
	String? kab2zonagempaId;
	ComboMKabZonaGempaModel? comboMKabZonaGempa;
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Regpar3FormModel({
		required this.regpar1Id,
		this.isEq, this.isFlexas,
		this.isOther, this.isRsmdcc,
		this.isTsfwd, required this.regpar3Id,
		this.kab2zonagempaId, this.comboMKabZonaGempa, this.mjnscoverparId, this.comboMJnscoverPar,
		this.mwilayahId, this.comboMWilayah});

	factory Regpar3FormModel.fromJson(Map<String, dynamic> data) {
		ComboMKabZonaGempaModel? comboMKabZonaGempa;
		if (data['comboMKabZonaGempa'] != null) {
			comboMKabZonaGempa = ComboMKabZonaGempaModel.fromJson(data['comboMKabZonaGempa']);
		}

		ComboMJnscoverParModel? comboMJnscoverPar;
		if (data['comboMJnscoverPar'] != null) {
			comboMJnscoverPar = ComboMJnscoverParModel.fromJson(data['comboMJnscoverPar']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		return Regpar3FormModel(
			regpar1Id: data['regpar1Id']??'',
			isEq: data['isEq'] as bool?,
			isFlexas: data['isFlexas'] as bool?,
			isOther: data['isOther'] as bool?,
			isRsmdcc: data['isRsmdcc'] as bool?,
			isTsfwd: data['isTsfwd'] as bool?,
			regpar3Id: data['regpar3Id']??'',
			kab2zonagempaId: data['kab2zonagempaId']??'',
			comboMKabZonaGempa: comboMKabZonaGempa,
			mjnscoverparId: data['mjnscoverparId']??'',
			comboMJnscoverPar: comboMJnscoverPar,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah,
		);

	}

	Map<String, dynamic> toJson() =>
			{
				'regpar1Id': regpar1Id,
				'isEq': isEq,
				'isFlexas': isFlexas,
				'isOther': isOther,
				'isRsmdcc': isRsmdcc,
				'isTsfwd': isTsfwd,
				'regpar3Id': regpar3Id,
				'kab2zonagempaId': kab2zonagempaId,
				'comboMKabZonaGempa': comboMKabZonaGempa?.toJson(),
				'mjnscoverparId': mjnscoverparId,
				'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
				'mwilayahId': mwilayahId,
				'comboMWilayah': comboMWilayah?.toJson()};

}