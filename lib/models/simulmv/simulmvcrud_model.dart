import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';

class SimulmvCrudModel {
	double? aw;
	int? coverBulan;
	double? harga;
	bool? isEq;
	bool? isFlood;
	bool? isSrcc;
	bool? isTerrorism;
	double? pad;
	double? pap;
	DateTime? periodeAkhir;
	DateTime? periodeMulai;
	double? pll;
	double? premiAdd;
	double? premiCasco;
	double? premiTotal;
	String? remarks;
	String? simulmv1Id;
	String? theinsured;
	int? thnBuat;
	double? tpl;
	String? mmvgrupojkId;
	ComboMMvgrupOjkModel? comboMMvgrupOjk;
	String? mmvjnscoverId;
	ComboMMvjnscoverModel? comboMMvjnscover;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;
	String? rmatauangKode;
	ComboRMatauangModel? comboRMatauang;

	SimulmvCrudModel({this.aw, this.coverBulan, 
		this.harga, this.isEq, 
		this.isFlood, this.isSrcc, 
		this.isTerrorism, this.pad, 
		this.pap, this.periodeAkhir, 
		this.periodeMulai, this.pll, 
		this.premiAdd, this.premiCasco, 
		this.premiTotal, this.remarks, 
		this.simulmv1Id, this.theinsured, 
		this.thnBuat, this.tpl, 
		this.mmvgrupojkId, this.comboMMvgrupOjk, this.mmvjnscoverId, this.comboMMvjnscover, 
		this.mwilayahId, this.comboMWilayah, this.rmatauangKode, this.comboRMatauang});

	factory SimulmvCrudModel.fromJson(Map<String, dynamic> data) {
		ComboMMvgrupOjkModel? comboMMvgrupOjk;
		if (data['comboMMvgrupOjk'] != null) {
			comboMMvgrupOjk = ComboMMvgrupOjkModel.fromJson(data['comboMMvgrupOjk']);
		}

		ComboMMvjnscoverModel? comboMMvjnscover;
		if (data['comboMMvjnscover'] != null) {
			comboMMvjnscover = ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		return SimulmvCrudModel(
			aw: double.tryParse(data['aw'].toString())??0,
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			harga: double.tryParse(data['harga'].toString())??0,
			isEq: data['isEq']??'',
			isFlood: data['isFlood']??'',
			isSrcc: data['isSrcc']??'',
			isTerrorism: data['isTerrorism']??'',
			pad: double.tryParse(data['pad'].toString())??0,
			pap: double.tryParse(data['pap'].toString())??0,
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			pll: double.tryParse(data['pll'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,
			remarks: data['remarks']??'',
			simulmv1Id: data['simulmv1Id']??'',
			theinsured: data['theinsured']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			tpl: double.tryParse(data['tpl'].toString())??0,
			mmvgrupojkId: data['mmvgrupojkId']??'',
			comboMMvgrupOjk: comboMMvgrupOjk,
			mmvjnscoverId: data['mmvjnscoverId']??'',
			comboMMvjnscover: comboMMvjnscover,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah,
			rmatauangKode: data['rmatauangKode']??'',
			comboRMatauang: comboRMatauang
		);

	}

	Map<String, dynamic> toJson() =>
		{'aw': aw.toString(),
		'coverBulan': coverBulan.toString(),
		'harga': harga.toString(),
		'isEq': isEq,
		'isFlood': isFlood,
		'isSrcc': isSrcc,
		'isTerrorism': isTerrorism,
		'pad': pad.toString(),
		'pap': pap.toString(),
		'periodeAkhir': periodeAkhir?.toIso8601String(),
		'periodeMulai': periodeMulai?.toIso8601String(),
		'pll': pll.toString(),
		'premiAdd': premiAdd.toString(),
		'premiCasco': premiCasco.toString(),
		'premiTotal': premiTotal.toString(),
		'remarks': remarks,
		'simulmv1Id': simulmv1Id,
		'theinsured': theinsured,
		'thnBuat': thnBuat.toString(),
		'tpl': tpl.toString(),
		'mmvgrupojkId': mmvgrupojkId,
		'comboMMvgrupOjk': comboMMvgrupOjk?.toJson(),
		'mmvjnscoverId': mmvjnscoverId,
		'comboMMvjnscover': comboMMvjnscover?.toJson(),
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson(),
		'rmatauangKode': rmatauangKode,
		'comboRMatauang': comboRMatauang?.toJson()};

}
