part of 'regother1crud_bloc.dart';

abstract class Regother1CrudEvents extends Equatable {
	const Regother1CrudEvents();

	@override
	List<Object> get props => [];
}

class Regother1CrudTambahEvent extends Regother1CrudEvents {
	final Regother1CrudModel record;
	const Regother1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regother1CrudUbahEvent extends Regother1CrudEvents {
	final Regother1CrudModel record;
	const Regother1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regother1CrudHapusEvent extends Regother1CrudEvents {
	final String recordId;
	const Regother1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regother1CrudLihatEvent extends Regother1CrudEvents {
	final String recordId;
	const Regother1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMCobApp1ChangedEvent extends Regother1CrudEvents{
	final ComboMCobApp1Model comboMCobApp1;
	const ComboMCobApp1ChangedEvent({required this.comboMCobApp1});

	@override	List<Object> get props => [comboMCobApp1];}

class ComboRMatauangChangedEvent extends Regother1CrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];
}

class ResetRegother1CrudEvent extends Regother1CrudEvents {}

