import 'package:equatable/equatable.dart';

class ComboMInsurerModel extends Equatable {
	final String minsurerId;
	final String insurerNama;

	const ComboMInsurerModel({this.minsurerId='', this.insurerNama=''});

	factory ComboMInsurerModel.fromJson(Map<String, dynamic> data) =>
		ComboMInsurerModel(
			minsurerId: data['minsurerId'],
			insurerNama: data['insurerNama']
		);

	Map<String, dynamic> toJson() =>
		{'minsurerId': minsurerId,
		'insurerNama': insurerNama};

	@override
	List<Object> get props => [minsurerId, insurerNama];
}
