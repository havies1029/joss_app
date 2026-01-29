import 'package:joss_app/models/combobox/combormatauang_model.dart';

class Regpar4FormModel {
	String regpar1Id;
	double siBuilding;
	double siContent;
	double siMachinery;
	double siOther;
	double siStock;
	String? currId;
	ComboRMatauangModel? comboRMatauang;

	Regpar4FormModel({required this.regpar1Id, required this.siBuilding, 
		required this.siContent, required this.siMachinery, 
		required this.siOther, required this.siStock, 
		this.currId, this.comboRMatauang});

	factory Regpar4FormModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return Regpar4FormModel(
			regpar1Id: data['regpar1Id']??'',
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
		{'regpar1Id': regpar1Id,
		'siBuilding': siBuilding.toString(),
		'siContent': siContent.toString(),
		'siMachinery': siMachinery.toString(),
		'siOther': siOther.toString(),
		'siStock': siStock.toString(),
		'currId': currId,
		'comboRMatauang': comboRMatauang?.toJson()};

	Regpar4FormModel copyWith({
		String? regpar1Id,
		double? siBuilding,
		double? siContent,
		double? siMachinery,
		double? siOther,
		double? siStock,
		String? currId,
		ComboRMatauangModel? comboRMatauang,
	}) {
		return Regpar4FormModel(
			regpar1Id: regpar1Id ?? this.regpar1Id,
			siBuilding: siBuilding ?? this.siBuilding,
			siContent: siContent ?? this.siContent,
			siMachinery: siMachinery ?? this.siMachinery,
			siOther: siOther ?? this.siOther,
			siStock: siStock ?? this.siStock,
			currId: currId ?? this.currId,
			comboRMatauang: comboRMatauang ?? this.comboRMatauang,
		);
	}

}
