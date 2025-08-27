import 'package:equatable/equatable.dart';

class ComboMMvtipeModel extends Equatable {
	final String mmvtipeId;
	final String nmTipe;

	const ComboMMvtipeModel({this.mmvtipeId='', this.nmTipe=''});

	factory ComboMMvtipeModel.fromJson(Map<String, dynamic> data) =>
		ComboMMvtipeModel(
			mmvtipeId: data['mmvtipeId'],
			nmTipe: data['nmTipe'],
		);

	Map<String, dynamic> toJson() =>
		{'mmvtipeId': mmvtipeId,
		'nmTipe': nmTipe,
		};

	@override
	List<Object> get props => [mmvtipeId, nmTipe];
}
