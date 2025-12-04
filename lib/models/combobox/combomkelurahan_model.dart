import 'package:equatable/equatable.dart';

class ComboMKelurahanModel extends Equatable {
	final String mkelurahanId;
	final String kelurahanNama;

	const ComboMKelurahanModel({this.mkelurahanId='', this.kelurahanNama=''});

	factory ComboMKelurahanModel.fromJson(Map<String, dynamic> data) =>
		ComboMKelurahanModel(
			mkelurahanId: data['mkelurahanId'],
			kelurahanNama: data['kelurahanNama'],
		);

	Map<String, dynamic> toJson() =>
		{'mkelurahanId': mkelurahanId,
		'kelurahanNama': kelurahanNama};

	@override
	List<Object> get props => [mkelurahanId, kelurahanNama];
}
