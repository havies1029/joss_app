
import 'package:joss_app/models/combobox/combominsurance_model.dart';

class Regklaim1CrudModel {
	String insuredNama;
	DateTime polisAkhir;
	DateTime polisMulai;
	String polisNo;
	String regklaim1Id;
  String lokasiObject;
	String? minsuranceId;
	ComboMInsuranceModel? comboMInsurance;

	Regklaim1CrudModel({required this.insuredNama, 
		required this.polisAkhir, required this.polisMulai, required this.polisNo,  
		required this.regklaim1Id, required this.lokasiObject,
    this.minsuranceId, this.comboMInsurance});

	factory Regklaim1CrudModel.fromJson(Map<String, dynamic> data) {
    ComboMInsuranceModel? comboMInsurance;
		if (data['comboMInsurance'] != null) {
			comboMInsurance = ComboMInsuranceModel.fromJson(data['comboMInsurance']);
		}

		return Regklaim1CrudModel(
			insuredNama: data['insuredNama']??'',
			polisAkhir: DateTime.tryParse(data['polisAkhir'].toString())??DateTime.now(),
			polisMulai: DateTime.tryParse(data['polisMulai'].toString())??DateTime.now(),
			polisNo: data['polisNo']??'',
			regklaim1Id: data['regklaim1Id']??'',
      lokasiObject: data['lokasiObject']??'',
			minsuranceId: data['minsuranceId']??'',
			comboMInsurance: comboMInsurance
		);

	}

	Map<String, dynamic> toJson() =>
		{'insuredNama': insuredNama,
		'polisAkhir': polisAkhir.toIso8601String(),
		'polisMulai': polisMulai.toIso8601String(),
		'polisNo': polisNo,
		'regklaim1Id': regklaim1Id,
    'lokasiObject': lokasiObject,
		'minsuranceId': minsuranceId,
		'comboMInsurance': comboMInsurance?.toJson()};

}
