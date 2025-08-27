import 'package:equatable/equatable.dart';

class ComboRKonstruksiojkModel extends Equatable {
	final String rkonstruksiojkId;
	final String kelasNama;
	final String alias1;

	const ComboRKonstruksiojkModel({this.rkonstruksiojkId='', this.kelasNama='', this.alias1=''});

	factory ComboRKonstruksiojkModel.fromJson(Map<String, dynamic> data) =>
		ComboRKonstruksiojkModel(
			rkonstruksiojkId: data['rkonstruksiojkId'],
			kelasNama: data['kelasNama'],
			alias1: data['alias1']
		);

	Map<String, dynamic> toJson() =>
		{'rkonstruksiojkId': rkonstruksiojkId,
		'kelasNama': kelasNama,
		'alias1': alias1};

	@override
	List<Object> get props => [rkonstruksiojkId, kelasNama, alias1];
}
