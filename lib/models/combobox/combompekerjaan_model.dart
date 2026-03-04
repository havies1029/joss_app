import 'package:equatable/equatable.dart';

class ComboMPekerjaanModel extends Equatable {
	final String mpekerjaanId;
	final String kerjaNama;

	const ComboMPekerjaanModel({this.mpekerjaanId='', this.kerjaNama=''});

	factory ComboMPekerjaanModel.fromJson(Map<String, dynamic> data) =>
		ComboMPekerjaanModel(
			mpekerjaanId: data['mpekerjaanId'],
			kerjaNama: data['kerjaNama']
		);

	Map<String, dynamic> toJson() =>
		{'mpekerjaanId': mpekerjaanId,
		'kerjaNama': kerjaNama};

	@override
	List<Object> get props => [mpekerjaanId, kerjaNama];
}
