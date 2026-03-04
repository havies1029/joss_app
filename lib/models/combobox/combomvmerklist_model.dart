import 'package:equatable/equatable.dart';

class ComboMvmerkListModel extends Equatable {
	final String mmvmerkId;
	final String nmMerk;
	final String migrasiId;

	const ComboMvmerkListModel({this.mmvmerkId='', this.nmMerk='', this.migrasiId=''});

	factory ComboMvmerkListModel.fromJson(Map<String, dynamic> data) =>
		ComboMvmerkListModel(
			mmvmerkId: data['mmvmerkId'],
			nmMerk: data['nmMerk'],
			migrasiId: data['migrasiId']
		);

	Map<String, dynamic> toJson() =>
		{'mmvmerkId': mmvmerkId,
		'nmMerk': nmMerk,
		'migrasiId': migrasiId};

	@override
	List<Object> get props => [mmvmerkId, nmMerk, migrasiId];
}
