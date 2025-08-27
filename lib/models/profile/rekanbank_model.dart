import 'package:joss_app/models/combobox/combombank_model.dart';

class RekanBankModel {
	String mrekan1Id;
	String mrekanbankId;
	String rekNama;
	String rekNo;
	String? mbankId;
	ComboMBankModel? comboMBank;

	RekanBankModel({required this.mrekan1Id, required this.mrekanbankId, 
		required this.rekNama, required this.rekNo, 
		this.mbankId, this.comboMBank});

	factory RekanBankModel.fromJson(Map<String, dynamic> data) {
		ComboMBankModel? comboMBank;
		if (data['comboMBank'] != null) {
			comboMBank = ComboMBankModel.fromJson(data['comboMBank']);
		}

		return RekanBankModel(
			mrekan1Id: data['mrekan1Id']??'',
			mrekanbankId: data['mrekanbankId']??'',
			rekNama: data['rekNama']??'',
			rekNo: data['rekNo']??'',
			mbankId: data['mbankId']??'',
			comboMBank: comboMBank
		);

	}

	Map<String, dynamic> toJson() =>
		{'mrekan1Id': mrekan1Id,
		'mrekanbankId': mrekanbankId,
		'rekNama': rekNama,
		'rekNo': rekNo,
		'mbankId': mbankId,
		'comboMBank': comboMBank?.toJson()};

}
