import 'package:equatable/equatable.dart';

class ComboMTipeCstModel extends Equatable {
	final String mtipecustId;
	final String tipeNama;

	const ComboMTipeCstModel({this.mtipecustId='', this.tipeNama=''});

	factory ComboMTipeCstModel.fromJson(Map<String, dynamic> data) =>
		ComboMTipeCstModel(
			mtipecustId: data['mtipecustId'],
			tipeNama: data['tipeNama']
		);

	Map<String, dynamic> toJson() =>
		{'mtipecustId': mtipecustId,
		'tipeNama': tipeNama};

	@override
	List<Object> get props => [mtipecustId, tipeNama];
}
