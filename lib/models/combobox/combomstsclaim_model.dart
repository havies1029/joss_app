import 'package:equatable/equatable.dart';

class ComboMStsclaimModel extends Equatable {
	final String mstsclaimId;
	final String statusNama;

	const ComboMStsclaimModel({this.mstsclaimId='', this.statusNama=''});

	factory ComboMStsclaimModel.fromJson(Map<String, dynamic> data) =>
		ComboMStsclaimModel(
			mstsclaimId: data['mstsclaimId'],
			statusNama: data['statusNama']
		);

	Map<String, dynamic> toJson() =>
		{'mstsclaimId': mstsclaimId,
		'statusNama': statusNama};

	@override
	List<Object> get props => [mstsclaimId, statusNama];
}
