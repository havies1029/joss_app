import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';

class Calpar2FormModel {
	double biIndexRate;
	double biTotal;
	String calpar2Id;
	String calpar1Id;
	double siBi;
	double siBuilding;
	double siContent;
	double siMachinery;
	double siOther;
	double siStock;
	double stockAdjustable;
	String? mbiindemnityojkId;
	ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
	String? rmatauangKode;
	ComboRMatauangModel? comboRMatauang;

	Calpar2FormModel({required this.biIndexRate, required this.biTotal,
		required this.calpar2Id, required this.calpar1Id, required this.siBi,
		required this.siBuilding, required this.siContent,
		required this.siMachinery, required this.siOther,
		required this.siStock, required this.stockAdjustable,
		this.mbiindemnityojkId, this.comboMBiindemnityOjk, this.rmatauangKode, this.comboRMatauang});

	factory Calpar2FormModel.fromJson(Map<String, dynamic> data) {
		ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
		if (data['comboMBiindemnityOjk'] != null) {
			comboMBiindemnityOjk = ComboMBiindemnityOjkModel.fromJson(data['comboMBiindemnityOjk']);
		}

		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return Calpar2FormModel(
			biIndexRate: double.tryParse(data['biIndexRate'].toString())??0,
			biTotal: double.tryParse(data['biTotal'].toString())??0,
			calpar2Id: data['calpar2Id']??'',
			calpar1Id: data['calpar1Id']??'',
			siBi: double.tryParse(data['siBi'].toString())??0,
			siBuilding: double.tryParse(data['siBuilding'].toString())??0,
			siContent: double.tryParse(data['siContent'].toString())??0,
			siMachinery: double.tryParse(data['siMachinery'].toString())??0,
			siOther: double.tryParse(data['siOther'].toString())??0,
			siStock: double.tryParse(data['siStock'].toString())??0,
			stockAdjustable: double.tryParse(data['stockAdjustable'].toString())??0,
			mbiindemnityojkId: data['mbiindemnityojkId']??'',
			comboMBiindemnityOjk: comboMBiindemnityOjk,
			rmatauangKode: data['rmatauangKode']??'',
			comboRMatauang: comboRMatauang
		);

	}

	Map<String, dynamic> toJson() =>
		{'biIndexRate': biIndexRate.toString(),
		'biTotal': biTotal.toString(),
		'calpar2Id': calpar2Id,
		'calpar1Id': calpar1Id,
		'siBi': siBi.toString(),
		'siBuilding': siBuilding.toString(),
		'siContent': siContent.toString(),
		'siMachinery': siMachinery.toString(),
		'siOther': siOther.toString(),
		'siStock': siStock.toString(),
		'stockAdjustable': stockAdjustable.toString(),
		'mbiindemnityojkId': mbiindemnityojkId,
		'comboMBiindemnityOjk': comboMBiindemnityOjk?.toJson(),
		'rmatauangKode': rmatauangKode,
		'comboRMatauang': comboRMatauang?.toJson()};

	Calpar2FormModel copyWith({
		double? biIndexRate,
		double? biTotal,
		String? calpar2Id,
		String? calpar1Id,
		double? siBi,
		double? siBuilding,
		double? siContent,
		double? siMachinery,
		double? siOther,
		double? siStock,
		double? stockAdjustable,
		String? mbiindemnityojkId,
		ComboMBiindemnityOjkModel? comboMBiindemnityOjk,
		String? rmatauangKode,
		ComboRMatauangModel? comboRMatauang,
	}) {
		return Calpar2FormModel(
			biIndexRate: biIndexRate ?? this.biIndexRate,
			biTotal: biTotal ?? this.biTotal,
			calpar2Id: calpar2Id ?? this.calpar2Id,
			calpar1Id: calpar1Id ?? this.calpar1Id,
			siBi: siBi ?? this.siBi,
			siBuilding: siBuilding ?? this.siBuilding,
			siContent: siContent ?? this.siContent,
			siMachinery: siMachinery ?? this.siMachinery,
			siOther: siOther ?? this.siOther,
			siStock: siStock ?? this.siStock,
			stockAdjustable: stockAdjustable ?? this.stockAdjustable,
			mbiindemnityojkId: mbiindemnityojkId ?? this.mbiindemnityojkId,
			comboMBiindemnityOjk:
			comboMBiindemnityOjk ?? this.comboMBiindemnityOjk,
			rmatauangKode: rmatauangKode ?? this.rmatauangKode,
			comboRMatauang: comboRMatauang ?? this.comboRMatauang,
		);
	}

	factory Calpar2FormModel.empty() {
		return Calpar2FormModel(
			biIndexRate: 0,
			biTotal: 0,
			calpar2Id: '',
			calpar1Id: '',
			siBi: 0,
			siBuilding: 0,
			siContent: 0,
			siMachinery: 0,
			siOther: 0,
			siStock: 0,
			stockAdjustable: 0,
			mbiindemnityojkId: null,
			comboMBiindemnityOjk: null,
			rmatauangKode: null,
			comboRMatauang: null,
		);
	}
}
