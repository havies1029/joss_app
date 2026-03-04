import 'package:joss_app/models/combobox/combomstsclaim_model.dart';

class Klaim2CrudModel {
	String keterangan;
	double klaimAmountBaru;
	double klaimAmountLama;
	String klaim2Id;
	DateTime perubahanTgl;
	String? mstsclaimId;
	ComboMStsclaimModel? comboMStsclaim;

	Klaim2CrudModel({required this.keterangan, required this.klaimAmountBaru, 
		required this.klaimAmountLama, required this.klaim2Id, 
		required this.perubahanTgl, this.mstsclaimId, this.comboMStsclaim});

	factory Klaim2CrudModel.fromJson(Map<String, dynamic> data) {
		ComboMStsclaimModel? comboMStsclaim;
		if (data['comboMStsclaim'] != null) {
			comboMStsclaim = ComboMStsclaimModel.fromJson(data['comboMStsclaim']);
		}

		return Klaim2CrudModel(
			keterangan: data['keterangan']??'',
			klaimAmountBaru: double.tryParse(data['klaimAmountBaru'].toString())??0,
			klaimAmountLama: double.tryParse(data['klaimAmountLama'].toString())??0,
			klaim2Id: data['klaim2Id']??'',
			perubahanTgl: DateTime.tryParse(data['perubahanTgl'].toString())??DateTime.now(),
			mstsclaimId: data['mstsclaimId']??'',
			comboMStsclaim: comboMStsclaim
		);

	}

	Map<String, dynamic> toJson() =>
		{'keterangan': keterangan,
		'klaimAmountBaru': klaimAmountBaru.toString(),
		'klaimAmountLama': klaimAmountLama.toString(),
		'klaim2Id': klaim2Id,
		'perubahanTgl': perubahanTgl.toIso8601String(),
		'mstsclaimId': mstsclaimId,
		'comboMStsclaim': comboMStsclaim?.toJson()};

}
