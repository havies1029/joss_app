import 'package:equatable/equatable.dart';

class ComboMMvjnscoverModel extends Equatable {
	final String mmvjnscoverId;
	final String coverName;

	const ComboMMvjnscoverModel({this.mmvjnscoverId='', this.coverName=''});

	factory ComboMMvjnscoverModel.fromJson(Map<String, dynamic> data) =>
		ComboMMvjnscoverModel(
			mmvjnscoverId: data['mmvjnscoverId'],
			coverName: data['coverName']
		);

	Map<String, dynamic> toJson() =>
		{'mmvjnscoverId': mmvjnscoverId,
		'coverName': coverName};

	@override
	List<Object> get props => [mmvjnscoverId, coverName];
}
