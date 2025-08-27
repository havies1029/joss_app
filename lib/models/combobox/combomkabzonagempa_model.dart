import 'package:equatable/equatable.dart';

class ComboMKabZonaGempaModel extends Equatable {
	final String mkabzonagempaId;
	final String kabupaten;
	final String propinsi;
	final String mzonagempaId;

	const ComboMKabZonaGempaModel({this.mkabzonagempaId='', this.kabupaten='', this.propinsi='', this.mzonagempaId=''});

	factory ComboMKabZonaGempaModel.fromJson(Map<String, dynamic> data) =>
		ComboMKabZonaGempaModel(
			mkabzonagempaId: data['mkabzonagempaId'],
			kabupaten: data['kabupaten'],
			propinsi: data['propinsi'],
			mzonagempaId: data['mzonagempaId']
		);

	Map<String, dynamic> toJson() =>
		{'mkabzonagempaId': mkabzonagempaId,
		'kabupaten': kabupaten,
		'propinsi': propinsi,
		'mzonagempaId': mzonagempaId};

	@override
	List<Object> get props => [mkabzonagempaId, kabupaten, propinsi, mzonagempaId];
}
