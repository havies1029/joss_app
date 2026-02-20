import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

class Calpar3FormModel {
	String calpar1Id;
	String calpar3Id;
	bool? isEq;
	bool? isFlexas;
	bool? isOther;
	bool? isRsmdcc;
	bool? isTsfwd;
	String? kab2zonagempaId;
	ComboMKabZonaGempaModel? comboMKabZonaGempa;
	String? mjnscoverparId;
	ComboMJnscoverParModel? comboMJnscoverPar;
	String? mwilayahId;
	ComboMWilayahModel? comboMWilayah;

	Calpar3FormModel({required this.calpar1Id, required this.calpar3Id, this.isEq,
		this.isFlexas, this.isOther,
		this.isRsmdcc, this.isTsfwd,
		this.kab2zonagempaId, this.comboMKabZonaGempa, this.mjnscoverparId, this.comboMJnscoverPar,
		this.mwilayahId, this.comboMWilayah});

	factory Calpar3FormModel.fromJson(Map<String, dynamic> data) {
		ComboMKabZonaGempaModel? comboMKabZonaGempa;
		if (data['comboMKabZonaGempa'] != null) {
			comboMKabZonaGempa = ComboMKabZonaGempaModel.fromJson(data['comboMKabZonaGempa']);
		}

		ComboMJnscoverParModel? comboMJnscoverPar;
		if (data['comboMJnscoverPar'] != null) {
			comboMJnscoverPar = ComboMJnscoverParModel.fromJson(data['comboMJnscoverPar']);
		}

		ComboMWilayahModel? comboMWilayah;
		if (data['comboMWilayah'] != null) {
			comboMWilayah = ComboMWilayahModel.fromJson(data['comboMWilayah']);
		}

		return Calpar3FormModel(
				calpar1Id: data['calpar1Id']??'',
				calpar3Id: data['calpar3Id']??'',
				isEq: data['isEq'] as bool?,
				isFlexas: data['isFlexas'] as bool?,
				isOther: data['isOther'] as bool?,
				isRsmdcc: data['isRsmdcc'] as bool?,
				isTsfwd: data['isTsfwd'] as bool?,
				kab2zonagempaId: data['kab2zonagempaId']??'',
				comboMKabZonaGempa: comboMKabZonaGempa,
				mjnscoverparId: data['mjnscoverparId']??'',
				comboMJnscoverPar: comboMJnscoverPar,
				mwilayahId: data['mwilayahId']??'',
				comboMWilayah: comboMWilayah
		);

	}

	Map<String, dynamic> toJson() =>
			{
				'calpar1Id': calpar1Id,
				'calpar3Id': calpar3Id,
				'isEq': isEq,
				'isFlexas': isFlexas,
				'isOther': isOther,
				'isRsmdcc': isRsmdcc,
				'isTsfwd': isTsfwd,
				'kab2zonagempaId': kab2zonagempaId,
				'comboMKabZonaGempa': comboMKabZonaGempa?.toJson(),
				'mjnscoverparId': mjnscoverparId,
				'comboMJnscoverPar': comboMJnscoverPar?.toJson(),
				'mwilayahId': mwilayahId,
				'comboMWilayah': comboMWilayah?.toJson()};

	Calpar3FormModel copyWith({
		String? calpar1Id,
		String? calpar3Id,
		bool? isEq,
		bool? isFlexas,
		bool? isOther,
		bool? isRsmdcc,
		bool? isTsfwd,
		String? kab2zonagempaId,
		ComboMKabZonaGempaModel? comboMKabZonaGempa,
		String? mjnscoverparId,
		ComboMJnscoverParModel? comboMJnscoverPar,
		String? mwilayahId,
		ComboMWilayahModel? comboMWilayah,
	}) {
		return Calpar3FormModel(
			calpar1Id: calpar1Id ?? this.calpar1Id,
			calpar3Id: calpar3Id ?? this.calpar3Id,
			isEq: isEq ?? this.isEq,
			isFlexas: isFlexas ?? this.isFlexas,
			isOther: isOther ?? this.isOther,
			isRsmdcc: isRsmdcc ?? this.isRsmdcc,
			isTsfwd: isTsfwd ?? this.isTsfwd,
			kab2zonagempaId: kab2zonagempaId ?? this.kab2zonagempaId,
			comboMKabZonaGempa: comboMKabZonaGempa ?? this.comboMKabZonaGempa,
			mjnscoverparId: mjnscoverparId ?? this.mjnscoverparId,
			comboMJnscoverPar: comboMJnscoverPar ?? this.comboMJnscoverPar,
			mwilayahId: mwilayahId ?? this.mwilayahId,
			comboMWilayah: comboMWilayah ?? this.comboMWilayah,
		);
	}

	factory Calpar3FormModel.empty() {
		return Calpar3FormModel(
			calpar1Id: '',
			calpar3Id: '',
			isEq: false,
			isFlexas: false,
			isOther: false,
			isRsmdcc: false,
			isTsfwd: false,
			kab2zonagempaId: null,
			comboMKabZonaGempa: null,
			mjnscoverparId: null,
			comboMJnscoverPar: null,
			mwilayahId: null,
			comboMWilayah: null,
		);
	}
}

