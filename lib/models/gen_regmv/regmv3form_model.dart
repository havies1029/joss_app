import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class Regmv3FormModel {
	String aksesoris;
	double harga;
	String mesinNo;
	String platNo;
	String rangkaNo;
	String regmv3Id;
	String regmv1Id;
	int thnBuat;
	String? mmvmerkId;
	ComboMMvmerkModel? comboMMvmerk;
	String? mmvmodelId;
	ComboMMvmodelModel? comboMMvmodel;
	String? mmvpakaiId;
	ComboMMvpakaiModel? comboMMvpakai;
	String? mmvtipeId;
	ComboMMvtipeModel? comboMMvtipe;
	String? mwarnaId;
	ComboMWarnaModel? comboMWarna;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Regmv3FormModel({required this.aksesoris, required this.harga, 
		required this.mesinNo, required this.platNo, 
		required this.rangkaNo, required this.regmv3Id, 
		required this.thnBuat, this.mmvmerkId, this.comboMMvmerk, 
		this.mmvmodelId, this.comboMMvmodel, this.mmvpakaiId, this.comboMMvpakai, 
		this.mmvtipeId, this.comboMMvtipe, this.mwarnaId, this.comboMWarna, 
		this.mwilayahId, this.comboMWilayah, required this.regmv1Id});

	factory Regmv3FormModel.fromJson(Map<String, dynamic> data) {
		ComboMMvmerkModel? comboMMvmerk;
		if (data['comboMMvmerk'] != null) {
			comboMMvmerk = ComboMMvmerkModel.fromJson(data['comboMMvmerk']);
		}

		ComboMMvmodelModel? comboMMvmodel;
		if (data['comboMMvmodel'] != null) {
			comboMMvmodel = ComboMMvmodelModel.fromJson(data['comboMMvmodel']);
		}

		ComboMMvpakaiModel? comboMMvpakai;
		if (data['comboMMvpakai'] != null) {
			comboMMvpakai = ComboMMvpakaiModel.fromJson(data['comboMMvpakai']);
		}

		ComboMMvtipeModel? comboMMvtipe;
		if (data['comboMMvtipe'] != null) {
			comboMMvtipe = ComboMMvtipeModel.fromJson(data['comboMMvtipe']);
		}

		ComboMWarnaModel? comboMWarna;
		if (data['comboMWarna'] != null) {
			comboMWarna = ComboMWarnaModel.fromJson(data['comboMWarna']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		return Regmv3FormModel(
			aksesoris: data['aksesoris']??'',
			harga: double.tryParse(data['harga'].toString())??0,
			mesinNo: data['mesinNo']??'',
			platNo: data['platNo']??'',
			rangkaNo: data['rangkaNo']??'',
			regmv3Id: data['regmv3Id']??'',
			regmv1Id: data['regmv1Id']??'',
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			mmvmerkId: data['mmvmerkId']??'',
			comboMMvmerk: comboMMvmerk,
			mmvmodelId: data['mmvmodelId']??'',
			comboMMvmodel: comboMMvmodel,
			mmvpakaiId: data['mmvpakaiId']??'',
			comboMMvpakai: comboMMvpakai,
			mmvtipeId: data['mmvtipeId']??'',
			comboMMvtipe: comboMMvtipe,
			mwarnaId: data['mwarnaId']??'',
			comboMWarna: comboMWarna,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah
		);

	}

	Map<String, dynamic> toJson() =>
		{'aksesoris': aksesoris,
		'harga': harga.toString(),
		'mesinNo': mesinNo,
		'platNo': platNo,
		'rangkaNo': rangkaNo,
		'regmv3Id': regmv3Id,
		'regmv1Id': regmv1Id,
		'thnBuat': thnBuat.toString(),
		'mmvmerkId': mmvmerkId,
		'comboMMvmerk': comboMMvmerk?.toJson(),
		'mmvmodelId': mmvmodelId,
		'comboMMvmodel': comboMMvmodel?.toJson(),
		'mmvpakaiId': mmvpakaiId,
		'comboMMvpakai': comboMMvpakai?.toJson(),
		'mmvtipeId': mmvtipeId,
		'comboMMvtipe': comboMMvtipe?.toJson(),
		'mwarnaId': mwarnaId,
		'comboMWarna': comboMWarna?.toJson(),
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson()};

}
