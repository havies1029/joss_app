import 'package:equatable/equatable.dart';

class ComboMJnsclientModel extends Equatable {
	final String mjnsclientId;
	final String jenisNama;

	const ComboMJnsclientModel({this.mjnsclientId='', this.jenisNama=''});

	factory ComboMJnsclientModel.fromJson(Map<String, dynamic> data) =>
		ComboMJnsclientModel(
			mjnsclientId: data['mjnsclientId'],
			jenisNama: data['jenisNama']
		);

	Map<String, dynamic> toJson() =>
		{'mjnsclientId': mjnsclientId,
		'jenisNama': jenisNama};

	@override
	List<Object> get props => [mjnsclientId, jenisNama];
}
