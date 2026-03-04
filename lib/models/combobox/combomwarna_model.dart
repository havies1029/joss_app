import 'package:equatable/equatable.dart';

class ComboMWarnaModel extends Equatable {
	final String mwarnaId;
	final String warnaDesc;

	const ComboMWarnaModel({this.mwarnaId='', this.warnaDesc=''});

	factory ComboMWarnaModel.fromJson(Map<String, dynamic> data) =>
		ComboMWarnaModel(
			mwarnaId: data['mwarnaId'],
			warnaDesc: data['warnaDesc']
		);

	Map<String, dynamic> toJson() =>
		{'mwarnaId': mwarnaId,
		'warnaDesc': warnaDesc};

	@override
	List<Object> get props => [mwarnaId, warnaDesc];
}
