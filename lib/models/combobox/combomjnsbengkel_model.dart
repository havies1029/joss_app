import 'package:equatable/equatable.dart';

class ComboMJnsbengkelModel extends Equatable {
	final String mjnsbengkelId;
	final String jenisNama;

	const ComboMJnsbengkelModel({this.mjnsbengkelId='', this.jenisNama=''});

	factory ComboMJnsbengkelModel.fromJson(Map<String, dynamic> data) =>
		ComboMJnsbengkelModel(
			mjnsbengkelId: data['mjnsbengkelId'],
			jenisNama: data['jenisNama']
		);

	Map<String, dynamic> toJson() =>
		{'mjnsbengkelId': mjnsbengkelId,
		'jenisNama': jenisNama};

	@override
	List<Object> get props => [mjnsbengkelId, jenisNama];
}
