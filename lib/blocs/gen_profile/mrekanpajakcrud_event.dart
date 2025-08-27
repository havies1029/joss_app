part of 'mrekanpajakcrud_bloc.dart';

abstract class MRekanPajakCrudEvents extends Equatable {
	const MRekanPajakCrudEvents();

	@override
	List<Object> get props => [];
}

class MRekanPajakCrudTambahEvent extends MRekanPajakCrudEvents {
	final MRekanPajakCrudModel record;
	const MRekanPajakCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanPajakCrudUbahEvent extends MRekanPajakCrudEvents {
	final MRekanPajakCrudModel record;
	const MRekanPajakCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanPajakCrudHapusEvent extends MRekanPajakCrudEvents {
	final String recordId;
	const MRekanPajakCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MRekanPajakCrudLihatEvent extends MRekanPajakCrudEvents {
	final String recordId;
	const MRekanPajakCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMPropinsiChangedEvent extends MRekanPajakCrudEvents{
	final ComboMPropinsiModel comboMPropinsi;
	const ComboMPropinsiChangedEvent({required this.comboMPropinsi});

	@override	List<Object> get props => [comboMPropinsi];}

class ComboMKotaChangedEvent extends MRekanPajakCrudEvents{
	final ComboMKotaModel comboMKota;
	const ComboMKotaChangedEvent({required this.comboMKota});

	@override	List<Object> get props => [comboMKota];}

class ComboRKodeposChangedEvent extends MRekanPajakCrudEvents{
	final ComboRKodeposModel comboRKodepos;
	const ComboRKodeposChangedEvent({required this.comboRKodepos});

	@override	List<Object> get props => [comboRKodepos];}

