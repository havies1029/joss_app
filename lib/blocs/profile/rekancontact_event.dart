part of 'rekancontact_bloc.dart';

abstract class RekanContactEvents extends Equatable {
	const RekanContactEvents();

	@override
	List<Object> get props => [];
}

class RekanContactTambahEvent extends RekanContactEvents {
	final RekanContactModel record;
	const RekanContactTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanContactUbahEvent extends RekanContactEvents {
	final RekanContactModel record;
	const RekanContactUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanContactHapusEvent extends RekanContactEvents {
	final String recordId;
	const RekanContactHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RekanContactLihatEvent extends RekanContactEvents {
	final String recordId;
	const RekanContactLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMPropinsiChangedEvent extends RekanContactEvents{
	final ComboMPropinsiModel comboMPropinsi;
	const ComboMPropinsiChangedEvent({required this.comboMPropinsi});

	@override	List<Object> get props => [comboMPropinsi];}

class ComboMKotaChangedEvent extends RekanContactEvents{
	final ComboMKotaModel comboMKota;
	const ComboMKotaChangedEvent({required this.comboMKota});

	@override	List<Object> get props => [comboMKota];}

class ComboRKodeposChangedEvent extends RekanContactEvents{
	final ComboRKodeposModel comboRKodepos;
	const ComboRKodeposChangedEvent({required this.comboRKodepos});

	@override	List<Object> get props => [comboRKodepos];}

