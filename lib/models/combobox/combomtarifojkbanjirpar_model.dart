import 'package:equatable/equatable.dart';

class ComboMTarifojkBanjirParModel extends Equatable {
	final String mtarifojkbanjirparId;
	final String kriteria;
	final String mzonaId;
	final String mwilayahId;
	final String zonaNama;
	final String wilayahNama;

	const ComboMTarifojkBanjirParModel({this.mtarifojkbanjirparId='', this.kriteria='', this.mzonaId='', this.mwilayahId='', this.zonaNama='', this.wilayahNama=''});

	factory ComboMTarifojkBanjirParModel.fromJson(Map<String, dynamic> data) =>
		ComboMTarifojkBanjirParModel(
			mtarifojkbanjirparId: data['mtarifojkbanjirparId'],
			kriteria: data['kriteria'],
			mzonaId: data['mzonaId'],
			mwilayahId: data['mwilayahId'],
			zonaNama: data['zonaNama'],
			wilayahNama: data['wilayahNama']
		);

	Map<String, dynamic> toJson() =>
		{'mtarifojkbanjirparId': mtarifojkbanjirparId,
		'kriteria': kriteria,
		'mzonaId': mzonaId,
		'mwilayahId': mwilayahId,
		'zonaNama': zonaNama,
		'wilayahNama': wilayahNama};

	@override
	List<Object> get props => [mtarifojkbanjirparId, kriteria, mzonaId, mwilayahId, zonaNama, wilayahNama];
}
