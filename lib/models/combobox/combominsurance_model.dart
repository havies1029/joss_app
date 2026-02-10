import 'package:equatable/equatable.dart';

class ComboMInsuranceModel extends Equatable {
	final String minsuranceId;
	final String insuranceName;
	final String singkatan;

	const ComboMInsuranceModel({this.minsuranceId='', this.insuranceName='', this.singkatan=''});

	factory ComboMInsuranceModel.fromJson(Map<String, dynamic> data) =>
		ComboMInsuranceModel(
			minsuranceId: data['minsuranceId'],
			insuranceName: data['insuranceName'],
			singkatan: data['singkatan'],
		);

	Map<String, dynamic> toJson() =>
		{'minsuranceId': minsuranceId,
		'insuranceName': insuranceName,
		'singkatan': singkatan,
    };

	@override
	List<Object> get props => [minsuranceId, insuranceName, singkatan];
}
