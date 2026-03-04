import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';

class Klaim1CrudModel {
	String insuredName;
	String kejadianLokasi;
	DateTime kejadianTgl;
	double klaimAmount;
	String klaim1Id;
	String? kursId;
	ComboRMatauangModel? comboRMatauang;
	String? lastStsclaimId;
	ComboMStsclaimModel? comboMStsclaim;

	Klaim1CrudModel({required this.insuredName, required this.kejadianLokasi, 
		required this.kejadianTgl, required this.klaimAmount, 
		required this.klaim1Id, this.kursId, this.comboRMatauang, 
		this.lastStsclaimId, this.comboMStsclaim});

	factory Klaim1CrudModel.fromJson(Map<String, dynamic> data) {
		ComboRMatauangModel? comboRMatauang;
		if (data['comboRMatauang'] != null) {
			comboRMatauang = ComboRMatauangModel.fromJson(data['comboRMatauang']);
		}

		ComboMStsclaimModel? comboMStsclaim;
		if (data['comboMStsclaim'] != null) {
			comboMStsclaim = ComboMStsclaimModel.fromJson(data['comboMStsclaim']);
		}

		return Klaim1CrudModel(
			insuredName: data['insuredName']??'',
			kejadianLokasi: data['kejadianLokasi']??'',
			kejadianTgl: DateTime.tryParse(data['kejadianTgl'].toString())??DateTime.now(),
			klaimAmount: double.tryParse(data['klaimAmount'].toString())??0,
			klaim1Id: data['klaim1Id']??'',
			kursId: data['kursId']??'',
			comboRMatauang: comboRMatauang,
			lastStsclaimId: data['lastStsclaimId']??'',
			comboMStsclaim: comboMStsclaim
		);

	}

	Map<String, dynamic> toJson() =>
		{'insuredName': insuredName,
		'kejadianLokasi': kejadianLokasi,
		'kejadianTgl': kejadianTgl.toIso8601String(),
		'klaimAmount': klaimAmount.toString(),
		'klaim1Id': klaim1Id,
		'kursId': kursId,
		'comboRMatauang': comboRMatauang?.toJson(),
		'lastStsclaimId': lastStsclaimId,
		'comboMStsclaim': comboMStsclaim?.toJson()};

}
