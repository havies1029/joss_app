import 'package:equatable/equatable.dart';

class ComboMJnskelModel extends Equatable {
	final String mjnskelId;
	final String jenisDesc;

	const ComboMJnskelModel({this.mjnskelId='', this.jenisDesc=''});

	factory ComboMJnskelModel.fromJson(Map<String, dynamic> data) =>
		ComboMJnskelModel(
			mjnskelId: data['mjnskelId'],
			jenisDesc: data['jenisDesc']
		);

	Map<String, dynamic> toJson() =>
		{'mjnskelId': mjnskelId,
		'jenisDesc': jenisDesc};

	@override
	List<Object> get props => [mjnskelId, jenisDesc];
}
