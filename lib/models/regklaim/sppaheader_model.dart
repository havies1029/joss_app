
import 'package:joss_app/models/regklaim/sppadetail_model.dart';

class SppaHeaderModel {
	String cobNama;
	String insuredNama;
	String objectAlamat1;
	String objectAlamat2;
	String sppa1Id;
  List<SppaDetailModel> sppaDetail;

	SppaHeaderModel({required this.cobNama, required this.insuredNama, 
		required this.objectAlamat1, required this.objectAlamat2, 
		required this.sppa1Id, required this.sppaDetail});

	factory SppaHeaderModel.fromJson(Map<String, dynamic> data) {
		return SppaHeaderModel(
			cobNama: data['cobNama']??'',
			insuredNama: data['insuredNama']??'',
			objectAlamat1: data['objectAlamat1']??'',
			objectAlamat2: data['objectAlamat2']??'',
			sppa1Id: data['sppa1Id']??'',
      sppaDetail: (data['sppaDetail'] as List<dynamic>?)
          ?.map((item) => SppaDetailModel.fromJson(item))
          .toList() ??
          []
		);

	}

	Map<String, dynamic> toJson() =>
		{'cobNama': cobNama,
		'insuredNama': insuredNama,
		'objectAlamat1': objectAlamat1,
		'objectAlamat2': objectAlamat2,
		'sppa1Id': sppa1Id,
    'sppaDetail': sppaDetail.map((item) => item.toJson()).toList()};

}
