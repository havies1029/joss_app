import 'package:equatable/equatable.dart';

class ComboMWilayahBengkelModel extends Equatable {
	final String mwilayahbengkelId;
	final String wilayahNama;

	const ComboMWilayahBengkelModel({this.mwilayahbengkelId='', this.wilayahNama=''});

	factory ComboMWilayahBengkelModel.fromJson(Map<String, dynamic> data) =>
		ComboMWilayahBengkelModel(
			mwilayahbengkelId: data['mwilayahbengkelId'],
			wilayahNama: data['wilayahNama']
		);

	Map<String, dynamic> toJson() =>
		{'mwilayahbengkelId': mwilayahbengkelId,
		'wilayahNama': wilayahNama};

	@override
	List<Object> get props => [mwilayahbengkelId, wilayahNama];
}
