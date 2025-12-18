import 'package:joss_app/models/combobox/combombank_model.dart';

class InvbayarvaFormModel {
	DateTime batasBayar;
	String invbayarvaId;
	String trsVaNoref;
	String vaNo;
	String? mbankId;
	ComboMBankModel? comboMBank;

	InvbayarvaFormModel({required this.batasBayar, required this.invbayarvaId, 
		required this.trsVaNoref, required this.vaNo, 
		this.mbankId, this.comboMBank});

	factory InvbayarvaFormModel.fromJson(Map<String, dynamic> data) {
		ComboMBankModel? comboMBank;
		if (data['comboMBank'] != null) {
			comboMBank = ComboMBankModel.fromJson(data['comboMBank']);
		}

		return InvbayarvaFormModel(
			batasBayar: DateTime.tryParse(data['batasBayar'].toString())??DateTime.now(),
			invbayarvaId: data['invbayarvaId']??'',
			trsVaNoref: data['trsVaNoref']??'',
			vaNo: data['vaNo']??'',
			mbankId: data['mbankId']??'',
			comboMBank: comboMBank
		);

	}

	Map<String, dynamic> toJson() =>
		{'batasBayar': batasBayar.toIso8601String(),
		'invbayarvaId': invbayarvaId,
		'trsVaNoref': trsVaNoref,
		'vaNo': vaNo,
		'mbankId': mbankId,
		'comboMBank': comboMBank?.toJson()};

}
