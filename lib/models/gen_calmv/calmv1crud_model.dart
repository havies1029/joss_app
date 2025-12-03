import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

import '../combobox/combommvpakai_model.dart';

class Calmv1CrudModel {
	String? regmv1Id;
	String calmv1Id;
	int coverBulan;
	String currId;
	double harga;
	int thnBuat;
	String? mmvgrupojkId;
	ComboMMvgrupOjkModel? comboMMvgrupOjk;
	String? mmvjnscoverId;
	ComboMMvjnscoverModel? comboMMvjnscover;
	String? mmvpakaiId;
	ComboMMvpakaiModel? comboMMvpakai;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Calmv1CrudModel({this.regmv1Id,required this.calmv1Id, required this.coverBulan,
		required this.currId, required this.harga,
		required this.thnBuat, this.mmvgrupojkId, this.comboMMvgrupOjk, this.mmvpakaiId, this.comboMMvpakai,
		this.mmvjnscoverId, this.comboMMvjnscover, this.mwilayahId, this.comboMWilayah});

	factory Calmv1CrudModel.fromJson(Map<String, dynamic> data) {
		ComboMMvgrupOjkModel? comboMMvgrupOjk;
		if (data['comboMMvgrupOjk'] != null) {
			comboMMvgrupOjk = ComboMMvgrupOjkModel.fromJson(data['comboMMvgrupOjk']);
		}

		ComboMMvjnscoverModel? comboMMvjnscover;
		if (data['comboMMvjnscover'] != null) {
			comboMMvjnscover = ComboMMvjnscoverModel.fromJson(data['comboMMvjnscover']);
		}

		ComboMMvpakaiModel? comboMMvpakai;
		if (data['comboMMvpakai'] != null) {
			comboMMvpakai = ComboMMvpakaiModel.fromJson(data['comboMMvpakai']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		return Calmv1CrudModel(
			regmv1Id: data['regmv1Id']??'',
			calmv1Id: data['calmv1Id']??'',
			coverBulan: int.tryParse(data['coverBulan'].toString())??0,
			currId: data['currId']??'',
			harga: double.tryParse(data['harga'].toString())??0,
			thnBuat: int.tryParse(data['thnBuat'].toString())??0,
			mmvgrupojkId: data['mmvgrupojkId']??'',
			comboMMvgrupOjk: comboMMvgrupOjk,
			mmvjnscoverId: data['mmvjnscoverId']??'',
			comboMMvjnscover: comboMMvjnscover,
			mmvpakaiId: data['mmvpakaiId']??'',
			comboMMvpakai: comboMMvpakai,
			mwilayahId: data['mwilayahId']??'',
			comboMWilayah: comboMWilayah
		);

	}

	Map<String, dynamic> toJson() =>
		{	'regmv1Id': regmv1Id,
			'calmv1Id': calmv1Id,
		'coverBulan': coverBulan.toString(),
		'currId': currId,
		'harga': harga.toString(),
		'thnBuat': thnBuat.toString(),
		'mmvgrupojkId': mmvgrupojkId,
		'comboMMvgrupOjk': comboMMvgrupOjk?.toJson(),
		'mmvjnscoverId': mmvjnscoverId,
		'comboMMvjnscover': comboMMvjnscover?.toJson(),
		'mmvpakaiId': mmvpakaiId,
		'comboMMvpakai': comboMMvpakai?.toJson(),
		'mwilayahId': mwilayahId,
		'comboMWilayah': comboMWilayah?.toJson()};
	Calmv1CrudModel copyWith({
		String? regmv1Id,
		String? calmv1Id,
		int? coverBulan,
		String? currId,
		double? harga,
		int? thnBuat,
		String? mmvgrupojkId,
		ComboMMvgrupOjkModel? comboMMvgrupOjk,
		String? mmvjnscoverId,
		ComboMMvjnscoverModel? comboMMvjnscover,
		String? mmvpakaiId,
		ComboMMvpakaiModel? comboMMvpakai,
		String? mwilayahId,
		ComboMWilayahModel? comboMWilayah,
	}) {
		return Calmv1CrudModel(
			regmv1Id: regmv1Id ?? this.regmv1Id,
			calmv1Id: calmv1Id ?? this.calmv1Id,
			coverBulan: coverBulan ?? this.coverBulan,
			currId: currId ?? this.currId,
			harga: harga ?? this.harga,
			thnBuat: thnBuat ?? this.thnBuat,
			mmvgrupojkId: mmvgrupojkId ?? this.mmvgrupojkId,
			comboMMvgrupOjk: comboMMvgrupOjk ?? this.comboMMvgrupOjk,
			mmvjnscoverId: mmvjnscoverId ?? this.mmvjnscoverId,
			comboMMvjnscover: comboMMvjnscover ?? this.comboMMvjnscover,
			mmvpakaiId: mmvpakaiId ?? this.mmvpakaiId,
			comboMMvpakai: comboMMvpakai ?? this.comboMMvpakai,
			mwilayahId: mwilayahId ?? this.mwilayahId,
			comboMWilayah: comboMWilayah ?? this.comboMWilayah,
		);
	}

}
