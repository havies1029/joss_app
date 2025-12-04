import 'package:equatable/equatable.dart';

class ComboMKecamatanModel extends Equatable {
	final String mkecamatanId;
	final String kecamatanNama;

	const ComboMKecamatanModel({this.mkecamatanId='', this.kecamatanNama=''});

	factory ComboMKecamatanModel.fromJson(Map<String, dynamic> data) =>
		ComboMKecamatanModel(
			mkecamatanId: data['mkecamatanId'],
			kecamatanNama: data['kecamatanNama'],
		);

	Map<String, dynamic> toJson() =>
		{'mkecamatanId': mkecamatanId,
		'kecamatanNama': kecamatanNama};

	@override
	List<Object> get props => [mkecamatanId, kecamatanNama];
}
