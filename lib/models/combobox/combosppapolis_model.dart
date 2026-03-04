import 'package:equatable/equatable.dart';

class ComboSppaPolisModel extends Equatable {
	final String sppaId;
	final String polisNo;

	const ComboSppaPolisModel({this.sppaId='', this.polisNo=''});

	factory ComboSppaPolisModel.fromJson(Map<String, dynamic> data) =>
		ComboSppaPolisModel(
			sppaId: data['sppaId'],
			polisNo: data['polisNo']
		);

	Map<String, dynamic> toJson() =>
		{'sppaId': sppaId,
		'polisNo': polisNo};

	@override
	List<Object> get props => [sppaId, polisNo];
}
