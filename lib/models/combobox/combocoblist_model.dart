import 'package:equatable/equatable.dart';

class ComboCobListModel extends Equatable {
	final String mCobApp1Id;
	final String cobNama;
	final String cobIcon;

	const ComboCobListModel({this.mCobApp1Id='', this.cobNama='', this.cobIcon=''});

	factory ComboCobListModel.fromJson(Map<String, dynamic> data) =>
		ComboCobListModel(
			mCobApp1Id: data['mCobApp1Id'],
			cobNama: data['cobNama'],
			cobIcon: data['cobIcon']
		);

	Map<String, dynamic> toJson() =>
		{'mCobApp1Id': mCobApp1Id,
		'cobNama': cobNama,
		'cobIcon': cobIcon};

	@override
	List<Object> get props => [mCobApp1Id, cobNama, cobIcon];
}
