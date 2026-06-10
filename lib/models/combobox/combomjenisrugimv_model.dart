import 'package:equatable/equatable.dart';

class ComboMJenisrugimvModel extends Equatable {
	final String mjenisrugimvId;
	final String jenisrugiNama;
	final int urutan;

	const ComboMJenisrugimvModel({this.mjenisrugimvId='', this.jenisrugiNama='', this.urutan=0});

	factory ComboMJenisrugimvModel.fromJson(Map<String, dynamic> data) =>
		ComboMJenisrugimvModel(
			mjenisrugimvId: data['mjenisrugimvId'],
			jenisrugiNama: data['jenisrugiNama'],
			urutan: data['urutan'],
		);

	Map<String, dynamic> toJson() =>
		{'mjenisrugimvId': mjenisrugimvId,
		'jenisrugiNama': jenisrugiNama,
		'urutan': urutan,
    };
      

	@override
	List<Object> get props => [mjenisrugimvId, jenisrugiNama, urutan];
}
