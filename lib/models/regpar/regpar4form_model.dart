import 'package:joss_app/models/combobox/combormatauang_model.dart';

class Regpar4FormModel {
	String regpar4Id;
	double siBuilding;
	double siContent;
	double siMachinery;
	double siOther;
	double siStock;
	String? currId;
	ComboRMatauangModel? comboRMatauang;

	Regpar4FormModel({required this.regpar4Id, required this.siBuilding, 
		required this.siContent, required this.siMachinery, 
		required this.siOther, required this.siStock, 
		this.currId, this.comboRMatauang});

	factory Regpar4FormModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return Regpar4FormModel(
			regpar4Id: data['regpar4Id']??'',
			siBuilding: double.tryParse(data['siBuilding'].toString())??0,
			siContent: double.tryParse(data['siContent'].toString())??0,
			siMachinery: double.tryParse(data['siMachinery'].toString())??0,
			siOther: double.tryParse(data['siOther'].toString())??0,
			siStock: double.tryParse(data['siStock'].toString())??0,
			currId: data['currId']??'',
			comboRMatauang: comboRMatauang
		);

	}

	Map<String, dynamic> toJson() =>
		{'regpar4Id': regpar4Id,
		'siBuilding': siBuilding.toString(),
		'siContent': siContent.toString(),
		'siMachinery': siMachinery.toString(),
		'siOther': siOther.toString(),
		'siStock': siStock.toString(),
		'currId': currId,
		'comboRMatauang': comboRMatauang?.toJson()};

}
