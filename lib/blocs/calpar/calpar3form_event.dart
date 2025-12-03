part of 'calpar3form_bloc.dart';

abstract class Calpar3FormEvents extends Equatable {
	const Calpar3FormEvents();

	@override
	List<Object> get props => [];
}

class Calpar3FormTambahEvent extends Calpar3FormEvents {
	final Calpar3FormModel record;
	const Calpar3FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar3FormUbahEvent extends Calpar3FormEvents {
	final Calpar3FormModel record;
	const Calpar3FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar3FormHapusEvent extends Calpar3FormEvents {
	final String recordId;
	const Calpar3FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calpar3FormLihatEvent extends Calpar3FormEvents {
	final String recordId;
	const Calpar3FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMWilayahChangedEvent extends Calpar3FormEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

<<<<<<< HEAD
class ComboMJnscoverParChangedEvent extends Calpar3FormEvents{
	final ComboMJnscoverParModel comboMJnscoverPar;
	const ComboMJnscoverParChangedEvent({required this.comboMJnscoverPar});

	@override	List<Object> get props => [comboMJnscoverPar];}

=======
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
class ComboMKabZonaGempaChangedEvent extends Calpar3FormEvents{
	final ComboMKabZonaGempaModel comboMKabZonaGempa;
	const ComboMKabZonaGempaChangedEvent({required this.comboMKabZonaGempa});

	@override	List<Object> get props => [comboMKabZonaGempa];}

