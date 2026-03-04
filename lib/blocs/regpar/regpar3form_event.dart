part of 'regpar3form_bloc.dart';

abstract class Regpar3FormEvents extends Equatable {
	const Regpar3FormEvents();

	@override
	List<Object> get props => [];
}

class Regpar3FormTambahEvent extends Regpar3FormEvents {
	final Regpar3FormModel record;
	const Regpar3FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar3FormUbahEvent extends Regpar3FormEvents {
	final Regpar3FormModel record;
	const Regpar3FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar3FormHapusEvent extends Regpar3FormEvents {
	final String recordId;
	const Regpar3FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar3FormLihatEvent extends Regpar3FormEvents {
	final String recordId;
	const Regpar3FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMJnscoverParChangedEvent extends Regpar3FormEvents{
	final ComboMJnscoverParModel comboMJnscoverPar;
	const ComboMJnscoverParChangedEvent({required this.comboMJnscoverPar});

	@override	List<Object> get props => [comboMJnscoverPar];}

class ComboMWilayahChangedEvent extends Regpar3FormEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

class ComboMKabZonaGempaChangedEvent extends Regpar3FormEvents{
	final ComboMKabZonaGempaModel comboMKabZonaGempa;
	const ComboMKabZonaGempaChangedEvent({required this.comboMKabZonaGempa});

	@override	List<Object> get props => [comboMKabZonaGempa];}

class Regpar3DraftEvent extends Regpar3FormEvents {
	final Regpar3FormModel record;
	const Regpar3DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

