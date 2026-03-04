part of 'rekanpajak_bloc.dart';

abstract class RekanPajakEvents extends Equatable {
	const RekanPajakEvents();

	@override
	List<Object> get props => [];
}

class RekanPajakTambahEvent extends RekanPajakEvents {
	final RekanPajakModel record;
	const RekanPajakTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanPajakUbahEvent extends RekanPajakEvents {
	final RekanPajakModel record;
	const RekanPajakUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanPajakHapusEvent extends RekanPajakEvents {
	final String recordId;
	const RekanPajakHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RekanPajakLihatEvent extends RekanPajakEvents {
	final String recordId;
	const RekanPajakLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMPropinsiChangedEvent extends RekanPajakEvents{
	final ComboMPropinsiModel comboMPropinsi;
	const ComboMPropinsiChangedEvent({required this.comboMPropinsi});

	@override	List<Object> get props => [comboMPropinsi];}

class ComboMKotaChangedEvent extends RekanPajakEvents{
	final ComboMKotaModel comboMKota;
	const ComboMKotaChangedEvent({required this.comboMKota});

	@override	List<Object> get props => [comboMKota];}

class ComboRKodeposChangedEvent extends RekanPajakEvents{
	final ComboRKodeposModel comboRKodepos;
	const ComboRKodeposChangedEvent({required this.comboRKodepos});

	@override	List<Object> get props => [comboRKodepos];}

