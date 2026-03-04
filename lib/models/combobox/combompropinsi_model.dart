import 'package:equatable/equatable.dart';

class ComboMPropinsiModel extends Equatable {
	final String mpropinsiId;
	final String propinsiNama;
	final String mwilayahId;

	const ComboMPropinsiModel({this.mpropinsiId='', this.propinsiNama='', this.mwilayahId=''});

	factory ComboMPropinsiModel.fromJson(Map<String, dynamic> data) =>
		ComboMPropinsiModel(
			mpropinsiId: data['mpropinsiId'],
			propinsiNama: data['propinsiNama'],
			mwilayahId: data['mwilayahId'] ?? ''
		);

	Map<String, dynamic> toJson() =>
		{'mpropinsiId': mpropinsiId,
		'propinsiNama': propinsiNama,
		'mwilayahId': mwilayahId};

	@override
	List<Object> get props => [mpropinsiId, propinsiNama, mwilayahId];
}
