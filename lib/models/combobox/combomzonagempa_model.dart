import 'package:equatable/equatable.dart';

class ComboMZonaGempaModel extends Equatable {
	final String mzonagempaId;
	final String zonaNama;

	const ComboMZonaGempaModel({this.mzonagempaId='', this.zonaNama=''});

	factory ComboMZonaGempaModel.fromJson(Map<String, dynamic> data) =>
		ComboMZonaGempaModel(
			mzonagempaId: data['mzonagempaId'],
			zonaNama: data['zonaNama']
		);

	Map<String, dynamic> toJson() =>
		{'mzonagempaId': mzonagempaId,
		'zonaNama': zonaNama};

	@override
	List<Object> get props => [mzonagempaId, zonaNama];
}
