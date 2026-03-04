
import 'package:joss_app/models/payment/dndetailsppa_model.dart';
import 'package:joss_app/models/payment/dnfootercob_model.dart';

class DnHeaderCobModel {
	String cobId;
	String cobNama;
  List<DnDetailSppaModel> details;
  List<DnFooterCobModel> footers;

	DnHeaderCobModel({required this.cobId, required this.cobNama, required this.details, required this.footers});

	factory DnHeaderCobModel.fromJson(Map<String, dynamic> data) {
		return DnHeaderCobModel(
			cobId: data['cobId']??'',
			cobNama: data['cobNama']??'',
      details: (data['details'] as List<dynamic>?)
          ?.map((item) => DnDetailSppaModel.fromJson(item))
          .toList() ?? [],
      footers: (data['footers'] as List<dynamic>?)
          ?.map((item) => DnFooterCobModel.fromJson(item))
          .toList() ?? []
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobId': cobId,
		'cobNama': cobNama,
    'details': details.map((item) => item.toJson()).toList(),
    'footers': footers.map((item) => item.toJson()).toList()
    };

}
