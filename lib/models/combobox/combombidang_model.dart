import 'package:equatable/equatable.dart';

class ComboMBidangModel extends Equatable {
	final String mbidangId;
	final String bidangNama;

	const ComboMBidangModel({this.mbidangId='', this.bidangNama=''});

	factory ComboMBidangModel.fromJson(Map<String, dynamic> data) =>
		ComboMBidangModel(
			mbidangId: data['mbidangId'],
			bidangNama: data['bidangNama']
		);

	Map<String, dynamic> toJson() =>
		{'mbidangId': mbidangId,
		'bidangNama': bidangNama};

	@override
	List<Object> get props => [mbidangId, bidangNama];
}
