import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class Calpar1CrudModel {
<<<<<<< HEAD
	String? regpar1Id;
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	String calpar1Id;
	int coverBulan;
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
	String? rkonstruksiojkId;
	ComboRKonstruksiojkModel? comboRKonstruksiojk;
	String? rokupasiId;
	ComboROkupasiModel? comboROkupasi;

<<<<<<< HEAD
	Calpar1CrudModel({this.regpar1Id,required this.calpar1Id, required this.coverBulan,
=======
	Calpar1CrudModel({required this.calpar1Id, required this.coverBulan, 
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		this.mjnscoverparId, this.comboMJnscoverPar, this.rkonstruksiojkId, this.comboRKonstruksiojk, 
		this.rokupasiId, this.comboROkupasi});

	factory Calpar1CrudModel.fromJson(Map<String, dynamic> data) {
		ComboMJnscoverParModel? comboMJnscoverPar;
		if (data['comboMJnscoverPar'] != null) {
			comboMJnscoverPar = ComboMJnscoverParModel.fromJson(data['comboMJnscoverPar']);
		}

		ComboRKonstruksiojkModel? comboRKonstruksiojk;
		if (data['comboRKonstruksiojk'] != null) {
			comboRKonstruksiojk = ComboRKonstruksiojkModel.fromJson(data['comboRKonstruksiojk']);
		}

		ComboROkupasiModel? comboROkupasi;
		if (data['comboROkupasi'] != null) {
			comboROkupasi = ComboROkupasiModel.fromJson(data['comboROkupasi']);
		}

		return Calpar1CrudModel(
<<<<<<< HEAD
			regpar1Id: data['regpar1Id']??'',
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			calpar1Id: data['calpar1Id']??'',
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			mjnscoverparId: data['mjnscoverparId']??'',
			comboMJnscoverPar: comboMJnscoverPar,
			rkonstruksiojkId: data['rkonstruksiojkId']??'',
			comboRKonstruksiojk: comboRKonstruksiojk,
			rokupasiId: data['rokupasiId']??'',
			comboROkupasi: comboROkupasi
		);

	}

	Map<String, dynamic> toJson() =>
<<<<<<< HEAD
		{
		'regpar1Id' : regpar1Id,
		'calpar1Id': calpar1Id,
=======
		{'calpar1Id': calpar1Id,
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		'coverBulan': coverBulan.toString(),
		'mjnscoverparId': mjnscoverparId,
		'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
		'rkonstruksiojkId': rkonstruksiojkId,
		'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
		'rokupasiId': rokupasiId,
		'comboROkupasi': comboROkupasi?.toJson()};

	Calpar1CrudModel copyWith({
<<<<<<< HEAD
		String? regpar1Id,
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
		String? calpar1Id,
		int? coverBulan,
		String? mjnscoverparId,
		ComboMJnscoverParModel? comboMJnscoverPar,
		String? rkonstruksiojkId,
		ComboRKonstruksiojkModel? comboRKonstruksiojk,
		String? rokupasiId,
		ComboROkupasiModel? comboROkupasi,
	}) {
		return Calpar1CrudModel(
<<<<<<< HEAD
			regpar1Id: regpar1Id ?? this.regpar1Id,
=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			calpar1Id: calpar1Id ?? this.calpar1Id,
			coverBulan: coverBulan ?? this.coverBulan,
			mjnscoverparId: mjnscoverparId ?? this.mjnscoverparId,
			comboMJnscoverPar: comboMJnscoverPar ?? this.comboMJnscoverPar,
			rkonstruksiojkId: rkonstruksiojkId ?? this.rkonstruksiojkId,
			comboRKonstruksiojk: comboRKonstruksiojk ?? this.comboRKonstruksiojk,
			rokupasiId: rokupasiId ?? this.rokupasiId,
			comboROkupasi: comboROkupasi ?? this.comboROkupasi,
		);
	}
}
