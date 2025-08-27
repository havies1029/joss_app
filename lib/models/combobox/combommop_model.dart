import 'package:equatable/equatable.dart';

class ComboMMopModel extends Equatable {
	final String mmopId;
	final String mopName;

	const ComboMMopModel({this.mmopId='', this.mopName=''});

	factory ComboMMopModel.fromJson(Map<String, dynamic> data) =>
		ComboMMopModel(
			mmopId: data['mmopId'],
			mopName: data['mopName'],
		);

	Map<String, dynamic> toJson() =>
		{'mmopId': mmopId,
		'mopName': mopName,
    };

	@override
	List<Object> get props => [mmopId, mopName];
}
