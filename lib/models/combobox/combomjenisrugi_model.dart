import 'package:equatable/equatable.dart';

class ComboMJenisrugiModel extends Equatable {
	final String mjenisrugiId;
	final String rugiDesc;

	const ComboMJenisrugiModel({this.mjenisrugiId='', this.rugiDesc=''});

	factory ComboMJenisrugiModel.fromJson(Map<String, dynamic> data) =>
		ComboMJenisrugiModel(
			mjenisrugiId: data['mjenisrugiId'],
			rugiDesc: data['rugiDesc'],
		);

	Map<String, dynamic> toJson() =>
		{'mjenisrugiId': mjenisrugiId,
		'rugiDesc': rugiDesc};

	@override
	List<Object> get props => [mjenisrugiId, rugiDesc];
}
