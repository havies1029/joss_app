import 'package:equatable/equatable.dart';

class ComboMJabatanModel extends Equatable {
	final String mjabatanId;
	final String jabatanDesc;

	const ComboMJabatanModel({this.mjabatanId='', this.jabatanDesc=''});

	factory ComboMJabatanModel.fromJson(Map<String, dynamic> data) =>
		ComboMJabatanModel(
			mjabatanId: data['mjabatanId'],
			jabatanDesc: data['jabatanDesc']
		);

	Map<String, dynamic> toJson() =>
		{'mjabatanId': mjabatanId,
		'jabatanDesc': jabatanDesc};

	@override
	List<Object> get props => [mjabatanId, jabatanDesc];
}
