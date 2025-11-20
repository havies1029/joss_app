import 'package:equatable/equatable.dart';

class ComboMJnscoverParModel extends Equatable {
	final String mjnscoverparId;
	final String jenisNama;

	const ComboMJnscoverParModel({this.mjnscoverparId='', this.jenisNama=''});

	factory ComboMJnscoverParModel.fromJson(Map<String, dynamic> data) =>
		ComboMJnscoverParModel(
			mjnscoverparId: data['mjnscoverparId'],
			jenisNama: data['jenisNama']
		);

	Map<String, dynamic> toJson() =>
		{'mjnscoverparId': mjnscoverparId,
		'jenisNama': jenisNama};

	@override
	List<Object> get props => [mjnscoverparId, jenisNama];
}
