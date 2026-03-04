import 'package:equatable/equatable.dart';

class ComboMZonaBanjirModel extends Equatable {
	final String mzonabanjirId;
	final String zonaNama;

	const ComboMZonaBanjirModel({this.mzonabanjirId='', this.zonaNama=''});

	factory ComboMZonaBanjirModel.fromJson(Map<String, dynamic> data) =>
		ComboMZonaBanjirModel(
			mzonabanjirId: data['mzonabanjirId'],
			zonaNama: data['zonaNama']
		);

	Map<String, dynamic> toJson() =>
		{'mzonabanjirId': mzonabanjirId,
		'zonaNama': zonaNama};

	@override
	List<Object> get props => [mzonabanjirId, zonaNama];
}
