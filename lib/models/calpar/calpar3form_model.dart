import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
<<<<<<< HEAD
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398

class Calpar3FormModel {
	String calpar3Id;
	String calpar1Id;
	bool isEq;
	bool isTsfwd;
	double rateEqvet;
	double rateOther;
	double ratePar;
	double rateRsmdcc;
	double rateTotal;
	double rateTsfwd;
	String? kab2zonagempaId;
	ComboMKabZonaGempaModel? comboMKabZonaGempa;
<<<<<<< HEAD
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Calpar3FormModel({required this.calpar3Id,required this.calpar1Id, required this.isEq,
<<<<<<< HEAD
		required this.isTsfwd, required this.rateEqvet,
		required this.rateOther, required this.ratePar,
		required this.rateRsmdcc, required this.rateTotal,
		required this.rateTsfwd, this.kab2zonagempaId, this.comboMKabZonaGempa, this.mjnscoverparId, this.comboMJnscoverPar,
=======
		required this.isTsfwd, required this.rateEqvet, 
		required this.rateOther, required this.ratePar, 
		required this.rateRsmdcc, required this.rateTotal, 
		required this.rateTsfwd, this.kab2zonagempaId, this.comboMKabZonaGempa, 
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		this.mwilayahId, this.comboMWilayah});

	factory Calpar3FormModel.fromJson(Map<String, dynamic> data) {
		ComboMKabZonaGempaModel? comboMKabZonaGempa;
		if (data['comboMKabZonaGempa'] != null) {
			comboMKabZonaGempa = ComboMKabZonaGempaModel.fromJson(data['comboMKabZonaGempa']);
		}

<<<<<<< HEAD
		ComboMJnscoverParModel? comboMJnscoverPar;
		if (data['comboMJnscoverPar'] != null) {
			comboMJnscoverPar = ComboMJnscoverParModel.fromJson(data['comboMJnscoverPar']);
		}

=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		return Calpar3FormModel(
			calpar3Id: data['calpar3Id']??'',
			calpar1Id: data['calpar1Id']??'',
			isEq: data['isEq']??'',
			isTsfwd: data['isTsfwd']??'',
			rateEqvet: double.tryParse(data['rateEqvet'].toString())??0,
			rateOther: double.tryParse(data['rateOther'].toString())??0,
			ratePar: double.tryParse(data['ratePar'].toString())??0,
			rateRsmdcc: double.tryParse(data['rateRsmdcc'].toString())??0,
			rateTotal: double.tryParse(data['rateTotal'].toString())??0,
			rateTsfwd: double.tryParse(data['rateTsfwd'].toString())??0,
			kab2zonagempaId: data['kab2zonagempaId']??'',
			comboMKabZonaGempa: comboMKabZonaGempa,
<<<<<<< HEAD
			mjnscoverparId: data['mjnscoverparId']??'',
			comboMJnscoverPar: comboMJnscoverPar,
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah
		);

	}

	Map<String, dynamic> toJson() =>
		{
<<<<<<< HEAD
		'calpar3Id': calpar3Id,
		'calpar1Id': calpar1Id,
=======
			'calpar3Id': calpar3Id,
			'calpar1Id': calpar1Id,
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		'isEq': isEq,
		'isTsfwd': isTsfwd,
		'rateEqvet': rateEqvet.toString(),
		'rateOther': rateOther.toString(),
		'ratePar': ratePar.toString(),
		'rateRsmdcc': rateRsmdcc.toString(),
		'rateTotal': rateTotal.toString(),
		'rateTsfwd': rateTsfwd.toString(),
		'kab2zonagempaId': kab2zonagempaId,
		'comboMKabZonaGempa': comboMKabZonaGempa?.toJson(),
<<<<<<< HEAD
		'mjnscoverparId': mjnscoverparId,
		'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson()};

}
