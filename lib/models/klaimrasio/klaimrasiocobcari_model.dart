
import 'package:joss_app/models/klaimrasio/klaimrasiodetailcari_model.dart';
import 'package:joss_app/models/klaimrasio/klaimrasiosumcurrcari_model.dart';

class KlaimrasiocobCariModel {
	String cobId;
	String cobNama;
  List<KlaimrasiodetailCariModel> details;
  List<KlaimrasiosumcurrCariModel> footers;

	KlaimrasiocobCariModel({required this.cobId, required this.cobNama, required this.details, required this.footers});

	factory KlaimrasiocobCariModel.fromJson(Map<String, dynamic> data) {
		return KlaimrasiocobCariModel(
			cobId: data['cobId']??'',
			cobNama: data['cobNama']??'',
      details: (data['details'] as List<dynamic>?)
          ?.map((e) => KlaimrasiodetailCariModel.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList() ??
          [],
      footers: (data['footers'] as List<dynamic>?)
          ?.map((e) =>KlaimrasiosumcurrCariModel.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList() ??
          []
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobId': cobId,
		'cobNama': cobNama,
    'details': details.map((d) => d.toJson()).toList(),
    'footers': footers.map((s) => s.toJson()).toList()};

}
