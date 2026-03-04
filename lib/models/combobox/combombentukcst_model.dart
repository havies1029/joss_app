import 'package:equatable/equatable.dart';

class ComboMBentukCstModel extends Equatable {
	final String mbentukcstId;
	final String bentukNama;

	const ComboMBentukCstModel({this.mbentukcstId='', this.bentukNama=''});

	factory ComboMBentukCstModel.fromJson(Map<String, dynamic> data) =>
		ComboMBentukCstModel(
			mbentukcstId: data['mbentukcstId'],
			bentukNama: data['bentukNama']
		);

	Map<String, dynamic> toJson() =>
		{'mbentukcstId': mbentukcstId,
		'bentukNama': bentukNama};

	@override
	List<Object> get props => [mbentukcstId, bentukNama];
}
