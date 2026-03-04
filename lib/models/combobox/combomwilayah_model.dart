import 'package:equatable/equatable.dart';

class ComboMWilayahModel extends Equatable {
	final String mwilayahId;
	final String wilayahNama;
	final String instypeId;

	const ComboMWilayahModel({this.mwilayahId='', this.wilayahNama='', this.instypeId=''});

	factory ComboMWilayahModel.fromJson(Map<String, dynamic> data) =>
		ComboMWilayahModel(
			mwilayahId: data['mwilayahId'],
			wilayahNama: data['wilayahNama'],
			instypeId: data['instypeId']
		);

	Map<String, dynamic> toJson() =>
		{'mwilayahId': mwilayahId,
		'wilayahNama': wilayahNama,
		'instypeId': instypeId};

	@override
	List<Object> get props => [mwilayahId, wilayahNama, instypeId];
}
