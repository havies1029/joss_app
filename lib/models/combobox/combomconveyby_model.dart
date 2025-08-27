import 'package:equatable/equatable.dart';

class ComboMConveybyModel extends Equatable {
	final String mconveybyId;
	final String conveybyNama;

	const ComboMConveybyModel({this.mconveybyId='', this.conveybyNama=''});

	factory ComboMConveybyModel.fromJson(Map<String, dynamic> data) =>
		ComboMConveybyModel(
			mconveybyId: data['mconveybyId'],
			conveybyNama: data['conveybyNama']
		);

	Map<String, dynamic> toJson() =>
		{'mconveybyId': mconveybyId,
		'conveybyNama': conveybyNama};

	@override
	List<Object> get props => [mconveybyId, conveybyNama];
}
