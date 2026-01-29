part of 'calpar1crud_bloc.dart';

abstract class Calpar1CrudEvents extends Equatable {
	const Calpar1CrudEvents();

	@override
	List<Object> get props => [];
}

class Calpar1CrudTambahEvent extends Calpar1CrudEvents {
	final Calpar1CrudModel record;
	const Calpar1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar1CrudUbahEvent extends Calpar1CrudEvents {
	final Calpar1CrudModel record;
	const Calpar1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar1CrudHapusEvent extends Calpar1CrudEvents {
	final String recordId;
	const Calpar1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calpar1CrudLihatEvent extends Calpar1CrudEvents {
	final String recordId;
	const Calpar1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboROkupasiChangedEvent extends Calpar1CrudEvents{
	final ComboROkupasiModel comboROkupasi;
	const ComboROkupasiChangedEvent({required this.comboROkupasi});

	@override	List<Object> get props => [comboROkupasi];}

class ComboRKonstruksiojkChangedEvent extends Calpar1CrudEvents{
	final ComboRKonstruksiojkModel comboRKonstruksiojk;
	const ComboRKonstruksiojkChangedEvent({required this.comboRKonstruksiojk});

	@override	List<Object> get props => [comboRKonstruksiojk];}

class ComboMJnscoverParChangedEvent extends Calpar1CrudEvents{
	final ComboMJnscoverParModel comboMJnscoverPar;
	const ComboMJnscoverParChangedEvent({required this.comboMJnscoverPar});

	@override	List<Object> get props => [comboMJnscoverPar];}


class Calpar1DraftEvent extends Calpar1CrudEvents {
	final Calpar1CrudModel record;
	const Calpar1DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}