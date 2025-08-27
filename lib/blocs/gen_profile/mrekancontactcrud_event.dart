part of 'mrekancontactcrud_bloc.dart';

abstract class MRekanContactCrudEvents extends Equatable {
	const MRekanContactCrudEvents();

	@override
	List<Object> get props => [];
}

class MRekanContactCrudUbahEvent extends MRekanContactCrudEvents {
	final MRekanContactCrudModel record;
	const MRekanContactCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanContactCrudLihatEvent extends MRekanContactCrudEvents {}

class ComboMPropinsiChangedEvent extends MRekanContactCrudEvents{
	final ComboMPropinsiModel comboMPropinsi;
	const ComboMPropinsiChangedEvent({required this.comboMPropinsi});

	@override	List<Object> get props => [comboMPropinsi];}

class ComboMKotaChangedEvent extends MRekanContactCrudEvents{
	final ComboMKotaModel comboMKota;
	const ComboMKotaChangedEvent({required this.comboMKota});

	@override	List<Object> get props => [comboMKota];}

class ComboRKodeposChangedEvent extends MRekanContactCrudEvents{
	final ComboRKodeposModel comboRKodepos;
	const ComboRKodeposChangedEvent({required this.comboRKodepos});

	@override	List<Object> get props => [comboRKodepos];}

