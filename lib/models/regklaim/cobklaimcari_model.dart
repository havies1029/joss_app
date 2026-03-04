
import 'package:joss_app/models/combobox/combominsurance_model.dart';

class CobklaimcariModel {
	String cobNama;
	String mcobklaim1Id;
  String mcobDefaultId;
	ComboMInsuranceModel? comboMInsurance;

	CobklaimcariModel({required this.cobNama, 
		required this.mcobklaim1Id,
    required this.mcobDefaultId,
    this.comboMInsurance});



	factory CobklaimcariModel.fromJson(Map<String, dynamic> data) {
		return CobklaimcariModel(
			cobNama: data['cobNama']??'',
			mcobklaim1Id: data['mcobklaim1Id']??'',
      mcobDefaultId: data['mcobDefaultId']??'',
      comboMInsurance: data['comboMInsurance'] != null ? ComboMInsuranceModel.fromJson(data['comboMInsurance']) : null
		);

	}

	Map<String, dynamic> toJson() =>
		{
		'cobNama': cobNama,
		'mcobklaim1Id': mcobklaim1Id,
    'mcobDefaultId': mcobDefaultId,
    'comboMInsurance': comboMInsurance?.toJson()
		};

}
