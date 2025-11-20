import 'package:equatable/equatable.dart';

class ComboMMvpakaiModel extends Equatable {
	final String mmvpakaiId;
	final String pakaiNama;

	const ComboMMvpakaiModel({this.mmvpakaiId='', this.pakaiNama=''});

	factory ComboMMvpakaiModel.fromJson(Map<String, dynamic> data) =>
		ComboMMvpakaiModel(
			mmvpakaiId: data['mmvpakaiId'],
			pakaiNama: data['pakaiNama']
		);

	Map<String, dynamic> toJson() =>
		{'mmvpakaiId': mmvpakaiId,
		'pakaiNama': pakaiNama};

	@override
	List<Object> get props => [mmvpakaiId, pakaiNama];
}
