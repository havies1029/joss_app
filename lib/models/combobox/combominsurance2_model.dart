import 'package:equatable/equatable.dart';

class ComboMInsurance2Model extends Equatable {
	final String minsuranceId;
	final String insuranceName;
	final String singkatan;

	const ComboMInsurance2Model({this.minsuranceId='', this.insuranceName='', this.singkatan=''});

	factory ComboMInsurance2Model.fromJson(Map<String, dynamic> data) =>
		ComboMInsurance2Model(
			minsuranceId: data['minsuranceId'] ?? '',
			insuranceName: data['insuranceName'] ?? '',
			singkatan: data['singkatan'] ?? '',
		);

	Map<String, dynamic> toJson() =>
		{'minsuranceId': minsuranceId,
		'insuranceName': insuranceName,
		'singkatan': singkatan,
	};

	@override
	List<Object> get props => [minsuranceId, insuranceName, singkatan];
}
