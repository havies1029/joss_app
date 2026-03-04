import 'package:equatable/equatable.dart';

class ComboROkupasiModel extends Equatable {
	final String rokupasiId;
	final String okupasiDesc;
	final String kodeOjk;

	const ComboROkupasiModel({this.rokupasiId='', this.okupasiDesc='', this.kodeOjk=''});

	factory ComboROkupasiModel.fromJson(Map<String, dynamic> data) =>
		ComboROkupasiModel(
			rokupasiId: data['rokupasiId'],
			okupasiDesc: data['okupasiDesc'],			
			kodeOjk: data['kodeOjk'],
		);

	Map<String, dynamic> toJson() =>
		{'rokupasiId': rokupasiId,
		'okupasiDesc': okupasiDesc,
		'kodeOjk': kodeOjk
  };

	@override
	List<Object> get props => [rokupasiId, okupasiDesc, kodeOjk];
}
