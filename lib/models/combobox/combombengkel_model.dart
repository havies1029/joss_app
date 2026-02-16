import 'package:equatable/equatable.dart';

class ComboMBengkelModel extends Equatable {
	final String mbengkelId;
	final String bengkelNama;
	final String mwilayahbengkelId;

	const ComboMBengkelModel({this.mbengkelId='', this.bengkelNama='', this.mwilayahbengkelId=''});

	factory ComboMBengkelModel.fromJson(Map<String, dynamic> data) =>
		ComboMBengkelModel(
			mbengkelId: data['mbengkelId'],
			bengkelNama: data['bengkelNama'],
			mwilayahbengkelId: data['mwilayahbengkelId'],
		);

	Map<String, dynamic> toJson() =>
		{'mbengkelId': mbengkelId,
		'bengkelNama': bengkelNama,
		'mwilayahbengkelId': mwilayahbengkelId,
		};

	@override
	List<Object> get props => [mbengkelId, bengkelNama, mwilayahbengkelId];
}
