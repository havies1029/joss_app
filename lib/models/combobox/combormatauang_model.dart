import 'package:equatable/equatable.dart';

class ComboRMatauangModel extends Equatable {
	final String rmatauangKode;
	final String rmatauangNama;
	final String rmatauangSimbol;

	const ComboRMatauangModel({this.rmatauangKode='', this.rmatauangNama='', this.rmatauangSimbol=''});

	factory ComboRMatauangModel.fromJson(Map<String, dynamic> data) =>
		ComboRMatauangModel(
			rmatauangKode: data['rmatauangKode'],
			rmatauangNama: data['rmatauangNama'],
			rmatauangSimbol: data['rmatauangSimbol']
		);

	Map<String, dynamic> toJson() =>
		{'rmatauangKode': rmatauangKode,
		'rmatauangNama': rmatauangNama,
		'rmatauangSimbol': rmatauangSimbol};

	@override
	List<Object> get props => [rmatauangKode, rmatauangNama, rmatauangSimbol];
}
