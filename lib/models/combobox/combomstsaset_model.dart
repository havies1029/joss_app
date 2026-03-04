import 'package:equatable/equatable.dart';

class ComboMStsasetModel extends Equatable {
	final String mstatusasetId;
	final String statusNama;

	const ComboMStsasetModel({this.mstatusasetId='', this.statusNama=''});

	factory ComboMStsasetModel.fromJson(Map<String, dynamic> data) =>
		ComboMStsasetModel(
			mstatusasetId: data['mstatusasetId'],
			statusNama: data['statusNama']
		);

	Map<String, dynamic> toJson() =>
		{'mstatusasetId': mstatusasetId,
		'statusNama': statusNama};

	@override
	List<Object> get props => [mstatusasetId, statusNama];
}
