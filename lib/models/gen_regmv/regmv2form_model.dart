import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';

class Regmv2FormModel {
	double aw;
	bool isEq;
	bool isFlood;
	bool isSrcc;
	bool isTbod;
	bool isTerrorism;
	double pad;
	double pap;
	int passangerCount;
	double pll;
	DateTime polisAkhir;
	DateTime polisMulai;
	String regmv2Id;
	String regmv1Id;
	double tpl;
	String? currId;
	ComboRMatauangModel? comboRMatauang;
	String? mmvjnscoverId;
	ComboMMvjnscoverModel? comboMMvjnscover;

	Regmv2FormModel({required this.aw, required this.isEq,
		required this.isFlood, required this.isSrcc,
		required this.isTbod, required this.isTerrorism,
		required this.pad, required this.pap,
		required this.passangerCount, required this.pll,
		required this.polisAkhir, required this.polisMulai,
		required this.regmv2Id, required this.regmv1Id,
		required this.tpl,
		this.currId, this.comboRMatauang, this.mmvjnscoverId, this.comboMMvjnscover});

	factory Regmv2FormModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		ComboMMvjnscoverModel? comboMMvjnscover;
		if (data['comboMMvjnscover'] != null) {
			comboMMvjnscover = ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
		}

		return Regmv2FormModel(
				aw: double.tryParse(data['aw'].toString())??0,
				isEq: data['isEq']??'',
				isFlood: data['isFlood']??'',
				isSrcc: data['isSrcc']??'',
				isTbod: data['isTbod']??'',
				isTerrorism: data['isTerrorism']??'',
				pad: double.tryParse(data['pad'].toString())??0,
				pap: double.tryParse(data['pap'].toString())??0,
				passangerCount: int.tryParse(data['passangerCount'].toString())??0,
				pll: double.tryParse(data['pll'].toString())??0,
				polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
				polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
				regmv2Id: data['regmv2Id']??'',
				regmv1Id: data['regmv1Id']??'',
				tpl: double.tryParse(data['tpl'].toString())??0,
				currId: data['currId']??'',
				comboRMatauang: comboRMatauang,
				mmvjnscoverId: data['mmvjnscoverId']??'',
				comboMMvjnscover: comboMMvjnscover
		);

	}

	Map<String, dynamic> toJson() =>
			{'aw': aw.toString(),
				'isEq': isEq,
				'isFlood': isFlood,
				'isSrcc': isSrcc,
				'isTbod': isTbod,
				'isTerrorism': isTerrorism,
				'pad': pad.toString(),
				'pap': pap.toString(),
				'passangerCount': passangerCount.toString(),
				'pll': pll.toString(),
				'polisAkhir': polisAkhir.toIso8601String(),
				'polisMulai': polisMulai.toIso8601String(),
				'regmv2Id': regmv2Id,
				'regmv1Id': regmv1Id,
				'tpl': tpl.toString(),
				'currId': currId,
				'comboRMatauang': comboRMatauang?.toJson(),
				'mmvjnscoverId': mmvjnscoverId,
				'comboMMvjnscover': comboMMvjnscover?.toJson()};

}
