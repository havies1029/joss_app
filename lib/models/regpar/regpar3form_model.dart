import 'package:joss_app/models/combobox/combomzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class Regpar3FormModel {
	bool isEq;
	double rateEqvet;
	double rateOther;
	double ratePar;
	double rateRsmdcc;
	double rateTotal;
	double rateTsfwd;
	String regpar3Id;
	String? kab2zonagempaId;
	ComboMZonaGempaModel? comboMZonaGempa;
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Regpar3FormModel({required this.isEq, required this.rateEqvet, 
		required this.rateOther, required this.ratePar, 
		required this.rateRsmdcc, required this.rateTotal, 
		required this.rateTsfwd, required this.regpar3Id, 
		this.kab2zonagempaId, this.comboMZonaGempa, this.mjnscoverparId, this.comboMJnscoverPar, 
		this.mwilayahId, this.comboMWilayah});

	factory Regpar3FormModel.fromJson(Map<String, dynamic> data) {
		ComboMZonaGempaModel? comboMZonaGempa;
		if (data['comboMZonaGempa'] != null) {
			comboMZonaGempa = ComboMZonaGempaModel.fromJson(data['comboMZonaGempa']);
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
			isEq: data['isEq']??'',
			rateEqvet: double.tryParse(data['rateEqvet'].toString())??0,
			rateOther: double.tryParse(data['rateOther'].toString())??0,
			ratePar: double.tryParse(data['ratePar'].toString())??0,
			rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString())??0,
			rateTotal: double.tryParse(data['rateTotal'].toString())??0,
			rateTsfwd: double.tryParse(data['rateTsfwd'].toString())??0,
			regpar3Id: data['regpar3Id']??'',
			kab2zonagempaId: data['kab2zonagempaId']??'',
			comboMZonaGempa: comboMZonaGempa,
			mjnscoverparId: data['mjnscoverparId']??'',
			comboMJnscoverPar: comboMJnscoverPar,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah
		);

	}

	Map<String, dynamic> toJson() =>
		{'isEq': isEq,
		'rateEqvet': rateEqvet.toString(),
		'rateOther': rateOther.toString(),
		'ratePar': ratePar.toString(),
		'rateRsmdcc': rateRsmdcc.toString(),
		'rateTotal': rateTotal.toString(),
		'rateTsfwd': rateTsfwd.toString(),
		'regpar3Id': regpar3Id,
		'kab2zonagempaId': kab2zonagempaId,
		'comboMZonaGempa': comboMZonaGempa?.toJson(),
		'mjnscoverparId': mjnscoverparId,
		'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson()};

}
