import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
// import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';

class SppamvCrudModel {
	double aw;
	double biayaPolis;
	double harga;
	String insuredAlamat1;
	String insuredAlamat2;
	String insuredNama;
	bool isEq;
	bool isFlood;
	bool isSrcc;
	bool isTerrorism;
	double materai;
	String mesinNo;
	double pad;
	double pap;
	DateTime periodeAkhir;
	DateTime periodeMulai;
	double pll;
	String polisiNo;
	double premi;
	double premiAdd;
	double premiCasco;
	double premiTotal;
	String rangkaNo;
	DateTime sppaTgl;
	String sppa1Id;
	int thnBuat;
	double tpl;
	double tsi;
	String? mmvgrupojkId;
	ComboMMvgrupOjkModel? comboMMvgrupOjk;
	String? mmvjnscoverId;
	ComboMMvjnscoverModel? comboMMvjnscover;
	String? mvmerkId;
	ComboMMvmerkModel? comboMMvmerk;
	String? mvtipeId;
	ComboMMvtipeModel? comboMMvtipe;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;
	String? warnaId;
	ComboMWarnaModel? comboMWarna;

	SppamvCrudModel({required this.aw, required this.biayaPolis, 
		required this.harga, required this.insuredAlamat1, 
		required this.insuredAlamat2, required this.insuredNama, 
		required this.isEq, required this.isFlood, 
		required this.isSrcc, required this.isTerrorism, 
		required this.materai, required this.mesinNo, 
		required this.pad, 
		required this.pap, required this.periodeAkhir, 
		required this.periodeMulai, required this.pll, 
		required this.polisiNo, required this.premi, 
		required this.premiAdd, required this.premiCasco, 
		required this.premiTotal, required this.rangkaNo, 
		required this.sppaTgl, required this.sppa1Id, 
		required this.thnBuat, required this.tpl, 
		required this.tsi, this.mmvgrupojkId, this.comboMMvgrupOjk, 
		this.mmvjnscoverId, this.comboMMvjnscover, this.mvmerkId, this.comboMMvmerk, 
		this.mvtipeId, this.comboMMvtipe, this.mwilayahId, this.comboMWilayah, 
		this.warnaId, this.comboMWarna});

	factory SppamvCrudModel.fromJson(Map<String, dynamic> data) {
		ComboMMvgrupOjkModel? comboMMvgrupOjk;
		if (data['comboMMvgrupOjk'] != null) {
			comboMMvgrupOjk = ComboMMvgrupOjkModel.fromJson(data['comboMMvgrupOjk']);
		}

		ComboMMvjnscoverModel? comboMMvjnscover;
		if (data['comboMMvjnscover'] != null) {
			comboMMvjnscover = ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
		}

		ComboMMvmerkModel? comboMMvmerk;
		if (data['comboMMvmerk'] != null) {
			comboMMvmerk = ComboMMvmerkModel.fromJson(data['comboMMvmerk']);
		}

		ComboMMvtipeModel? comboMMvtipe;
		if (data['comboMMvtipe'] != null) {
			comboMMvtipe = ComboMMvtipeModel.fromJson(data['comboMMvtipe']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		ComboMWarnaModel? comboMWarna;
		if (data['comboMWarna'] != null) {
			comboMWarna = ComboMWarnaModel.fromJson(data['comboMWarna']);
		}

		return SppamvCrudModel(
			aw: double.tryParse(data['aw'].toString())??0, //authorized workshop
			biayaPolis: double.tryParse(data['biayaPolis'].toString())??0,
			harga: double.tryParse(data['harga'].toString())??0, //harga kendaraan
			insuredAlamat1: data['insuredAlamat1']??'',
			insuredAlamat2: data['insuredAlamat2']??'',
			insuredNama: data['insuredNama']??'',
			isEq: data['isEq']??'',
			isFlood: data['isFlood']??'',
			isSrcc: data['isSrcc']??'',
			isTerrorism: data['isTerrorism']??'',
			materai: double.tryParse(data['materai'].toString())??0,
			mesinNo: data['mesinNo']??'',
			pad: double.tryParse(data['pad'].toString())??0, //pa driver
			pap: double.tryParse(data['pap'].toString())??0, // passenger liability
			periodeAkhir: DateTime.tryParse(data['periodeAkhir'].toString())??DateTime.now(),
			periodeMulai: DateTime.tryParse(data['periodeMulai'].toString())??DateTime.now(),
			pll: double.tryParse(data['pll'].toString())??0,
			polisiNo: data['polisiNo']??'',
			premi: double.tryParse(data['premi'].toString())??0,
			premiAdd: double.tryParse(data['premiAdd'].toString())??0,
			premiCasco: double.tryParse(data['premiCasco'].toString())??0,
			premiTotal: double.tryParse(data['premiTotal'].toString())??0,
			rangkaNo: data['rangkaNo']??'',
			sppaTgl: DateTime.tryParse(data['sppaTgl'].toString())??DateTime.now(),
			sppa1Id: data['sppa1Id']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0, //dropdown tahun
			tpl: double.tryParse(data['tpl'].toString())??0, //
			tsi: double.tryParse(data['tsi'].toString())??0,
			mmvgrupojkId: data['mmvgrupojkId']??'', //jenis kendaraan
			comboMMvgrupOjk: comboMMvgrupOjk, //jenis kendaraan
			mmvjnscoverId: data['mmvjnscoverId']??'',
			comboMMvjnscover: comboMMvjnscover, //jenis cover
			mvmerkId: data['mvmerkId']??'',
			comboMMvmerk: comboMMvmerk,
			mvtipeId: data['mvtipeId']??'',
			comboMMvtipe: comboMMvtipe,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah,
			warnaId: data['warnaId']??'',
			comboMWarna: comboMWarna
		);

	}

	Map<String, dynamic> toJson() =>
		{'aw': aw.toString(),
		'biayaPolis': biayaPolis.toString(),
		'harga': harga.toString(),
		'insuredAlamat1': insuredAlamat1,
		'insuredAlamat2': insuredAlamat2,
		'insuredNama': insuredNama,
		'isEq': isEq,
		'isFlood': isFlood,
		'isSrcc': isSrcc,
		'isTerrorism': isTerrorism,
		'materai': materai.toString(),
		'mesinNo': mesinNo,
		'pad': pad.toString(),
		'pap': pap.toString(),
		'periodeAkhir': periodeAkhir.toIso8601String(),
		'periodeMulai': periodeMulai.toIso8601String(),
		'pll': pll.toString(),
		'polisiNo': polisiNo,
		'premi': premi.toString(),
		'premiAdd': premiAdd.toString(),
		'premiCasco': premiCasco.toString(),
		'premiTotal': premiTotal.toString(),
		'rangkaNo': rangkaNo,
		'sppaTgl': sppaTgl.toIso8601String(),
		'sppa1Id': sppa1Id,
		'thnBuat': thnBuat.toString(),
		'tpl': tpl.toString(),
		'tsi': tsi.toString(),
		'mmvgrupojkId': mmvgrupojkId,
		'comboMMvgrupOjk': comboMMvgrupOjk?.toJson(),
		'mmvjnscoverId': mmvjnscoverId,
		'comboMMvjnscover': comboMMvjnscover?.toJson(),
		'mvmerkId': mvmerkId,
		'comboMMvmerk': comboMMvmerk?.toJson(),
		'mvtipeId': mvtipeId,
		'comboMMvtipe': comboMMvtipe?.toJson(),
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson(),
		'warnaId': warnaId,
		'comboMWarna': comboMWarna?.toJson()};

}
