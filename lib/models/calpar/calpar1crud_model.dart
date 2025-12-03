import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class Calpar1CrudModel {
	String? regpar1Id;
	String calpar1Id;
	int coverBulan;
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
	String? rkonstruksiojkId;
	ComboRKonstruksiojkModel? comboRKonstruksiojk;
	String? rokupasiId;
	ComboROkupasiModel? comboROkupasi;

	Calpar1CrudModel({this.regpar1Id,required this.calpar1Id, required this.coverBulan,
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
			regpar1Id: data['regpar1Id']??'',
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
		{
		'regpar1Id' : regpar1Id,
		'calpar1Id': calpar1Id,
		'coverBulan': coverBulan.toString(),
		'mjnscoverparId': mjnscoverparId,
		'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
		'rkonstruksiojkId': rkonstruksiojkId,
		'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
		'rokupasiId': rokupasiId,
		'comboROkupasi': comboROkupasi?.toJson()};

	Calpar1CrudModel copyWith({
		String? regpar1Id,
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
			regpar1Id: regpar1Id ?? this.regpar1Id,
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
