import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';

class Regpar2FormModel {
	int coverLama;
	DateTime polisAkhir;
	DateTime polisMulai;
	String regpar2Id;
	String? rkonstruksiojkId;
	ComboRKonstruksiojkModel? comboRKonstruksiojk;
	String? rokupasiId;
	ComboROkupasiModel? comboROkupasi;

	Regpar2FormModel({required this.coverLama, required this.polisAkhir, 
		required this.polisMulai, required this.regpar2Id, 
		this.rkonstruksiojkId, this.comboRKonstruksiojk, this.rokupasiId, this.comboROkupasi});

	factory Regpar2FormModel.fromJson(Map<String, dynamic> data) {
		ComboRKonstruksiojkModel? comboRKonstruksiojk;
		if (data['comboRKonstruksiojk'] != null) {
			comboRKonstruksiojk = ComboRKonstruksiojkModel.fromJson(data['comboRKonstruksiojk']);
		}

		ComboROkupasiModel? comboROkupasi;
		if (data['comboROkupasi'] != null) {
			comboROkupasi = ComboROkupasiModel.fromJson(data['comboROkupasi']);
		}

		return Regpar2FormModel(
			coverLama: int.tryParse(data['coverLama'].toString())??0,
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
			regpar2Id: data['regpar2Id']??'',
			rkonstruksiojkId: data['rkonstruksiojkId']??'',
			comboRKonstruksiojk: comboRKonstruksiojk,
			rokupasiId: data['rokupasiId']??'',
			comboROkupasi: comboROkupasi
		);

	}

	Map<String, dynamic> toJson() =>
		{'coverLama': coverLama.toString(),
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
		'regpar2Id': regpar2Id,
		'rkonstruksiojkId': rkonstruksiojkId,
		'comboRKonstruksiojk': comboRKonstruksiojk?.toJson(),
		'rokupasiId': rokupasiId,
		'comboROkupasi': comboROkupasi?.toJson()};

}
