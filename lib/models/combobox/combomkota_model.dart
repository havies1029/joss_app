import 'package:equatable/equatable.dart';

class ComboMKotaModel extends Equatable {
	final String mkotaId;
	final String kotaDesc;

	const ComboMKotaModel({this.mkotaId='', this.kotaDesc=''});

	factory ComboMKotaModel.fromJson(Map<String, dynamic> data) =>
		ComboMKotaModel(
			mkotaId: data['mkotaId'],
			kotaDesc: data['kotaDesc'],
		);

	Map<String, dynamic> toJson() =>
		{'mkotaId': mkotaId,
		'kotaDesc': kotaDesc,};

	@override
	List<Object> get props => [mkotaId, kotaDesc];
}
