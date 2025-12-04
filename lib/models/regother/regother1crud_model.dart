import 'package:joss_app/models/combobox/combormatauang_model.dart';
import '../combobox/combomcobapp1_model.dart';

class Regother1CrudModel {
	String regother1Id;
	String? mCobApp1Id;
	String remark;
	double tsi;
	String? currId;
	ComboRMatauangModel? comboRMatauang;
	ComboMCobApp1Model? comboMCobApp1;

	Regother1CrudModel({required this.regother1Id, this.comboMCobApp1, required this.remark,
		required this.tsi, this.currId,this.mCobApp1Id, this.comboRMatauang});

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
				comboMCobApp1:comboMCobApp1,
			remark: data['remark']??'',
			tsi: double.tryParse(data['tsi'].toString())??0,
			currId: data['currId']??'',
				mCobApp1Id: data['mCobApp1Id']??'',
			comboRMatauang: comboRMatauang
		);

	}

	Map<String, dynamic> toJson() =>
		{'regother1Id': regother1Id,'comboMCobApp1': comboMCobApp1?.toJson(),
		'remark': remark,
		'tsi': tsi.toString(),
		'currId': currId,
			'mcobId': mCobApp1Id,
			'comboRMatauang': comboRMatauang?.toJson()};

}
