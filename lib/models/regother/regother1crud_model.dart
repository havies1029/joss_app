import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';

class Regother1CrudModel {
	String regother1Id;
	String remark;
	double tsi;
	String? currId;
	ComboRMatauangModel? comboRMatauang;
	String? mcobId;
	ComboMCobApp1Model? comboMCobApp1;

	Regother1CrudModel({required this.regother1Id, required this.remark,
		required this.tsi, this.currId, this.comboRMatauang,
		this.mcobId, this.comboMCobApp1});

	factory Regother1CrudModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		ComboMCobApp1Model? comboMCobApp1;
		if (data['comboMCobApp1'] != null) {
			comboMCobApp1 = ComboMCobApp1Model.fromJson(data['comboMCobApp1']);
		}

		return Regother1CrudModel(
				regother1Id: data['regother1Id']??'',
				remark: data['remark']??'',
				tsi: double.tryParse(data['tsi'].toString())??0,
				currId: data['currId']??'',
				comboRMatauang: comboRMatauang,
				mcobId: data['mcobId']??'',
				comboMCobApp1: comboMCobApp1
		);

	}

	Map<String, dynamic> toJson() =>
			{'regother1Id': regother1Id,
				'remark': remark,
				'tsi': tsi.toString(),
				'currId': currId,
				'comboRMatauang': comboRMatauang?.toJson(),
				'mcobId': mcobId,
				'comboMCobApp1': comboMCobApp1?.toJson()};

}
