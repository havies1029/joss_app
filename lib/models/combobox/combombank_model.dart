import 'package:equatable/equatable.dart';

class ComboMBankModel extends Equatable {
	final String mbankId;
	final String bankNama;

	const ComboMBankModel({this.mbankId='', this.bankNama=''});

	factory ComboMBankModel.fromJson(Map<String, dynamic> data) =>
		ComboMBankModel(
			mbankId: data['mbankId'],
			bankNama: data['bankNama']
		);

	Map<String, dynamic> toJson() =>
		{'mbankId': mbankId,
		'bankNama': bankNama};

	@override
	List<Object> get props => [mbankId, bankNama];
}
