import 'package:equatable/equatable.dart';

class ComboMMvmerkModel extends Equatable {
	final String mmvmerkId;
	final String nmMerk;

	const ComboMMvmerkModel({this.mmvmerkId='', this.nmMerk=''});

	factory ComboMMvmerkModel.fromJson(Map<String, dynamic> data) =>
		ComboMMvmerkModel(
			mmvmerkId: data['mmvmerkId'],
			nmMerk: data['nmMerk'],
		);

	Map<String, dynamic> toJson() =>
		{'mmvmerkId': mmvmerkId,
		'nmMerk': nmMerk};

	@override
	List<Object> get props => [mmvmerkId, nmMerk];
}
