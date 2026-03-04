import 'package:equatable/equatable.dart';

class ComboMMvgrupOjkModel extends Equatable {
	final String mmvgrupojkId;
	final String grupNama;
	final String mmvgrupId;

	const ComboMMvgrupOjkModel({this.mmvgrupojkId='', this.grupNama='', this.mmvgrupId=''});

	factory ComboMMvgrupOjkModel.fromJson(Map<String, dynamic> data) =>
		ComboMMvgrupOjkModel(
			mmvgrupojkId: data['mmvgrupojkId'],
			grupNama: data['grupNama'],
			mmvgrupId: data['mmvgrupId']
		);

	Map<String, dynamic> toJson() =>
		{'mmvgrupojkId': mmvgrupojkId,
		'grupNama': grupNama,
		'mmvgrupId': mmvgrupId};

	@override
	List<Object> get props => [mmvgrupojkId, grupNama, mmvgrupId];
}
