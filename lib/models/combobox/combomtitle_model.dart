import 'package:equatable/equatable.dart';

class ComboMTitleModel extends Equatable {
	final String mtitleId;
	final String titleDesc;

	const ComboMTitleModel({this.mtitleId='', this.titleDesc=''});

	factory ComboMTitleModel.fromJson(Map<String, dynamic> data) =>
		ComboMTitleModel(
			mtitleId: data['mtitleId'],
			titleDesc: data['titleDesc']
		);

	Map<String, dynamic> toJson() =>
		{'mtitleId': mtitleId,
		'titleDesc': titleDesc};

	@override
	List<Object> get props => [mtitleId, titleDesc];
}
