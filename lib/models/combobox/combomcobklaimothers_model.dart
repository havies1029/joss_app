import 'package:equatable/equatable.dart';

class ComboMCobKlaimOthersModel extends Equatable {
	final String mcobId;
	final String cobNama;

	const ComboMCobKlaimOthersModel({this.mcobId='', this.cobNama=''});

	factory ComboMCobKlaimOthersModel.fromJson(Map<String, dynamic> data) =>
		ComboMCobKlaimOthersModel(
			mcobId: data['mcobId'],
			cobNama: data['cobNama']
		);

	Map<String, dynamic> toJson() =>
		{'mcobId': mcobId,
		'cobNama': cobNama};

	@override
	List<Object> get props => [mcobId, cobNama];
}
