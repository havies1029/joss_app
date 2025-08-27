part of 'klaim1crud_bloc.dart';

abstract class Klaim1CrudEvents extends Equatable {
	const Klaim1CrudEvents();

	@override
	List<Object> get props => [];
}

class Klaim1CrudTambahEvent extends Klaim1CrudEvents {
	final Klaim1CrudModel record;
	const Klaim1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Klaim1CrudUbahEvent extends Klaim1CrudEvents {
	final Klaim1CrudModel record;
	const Klaim1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Klaim1CrudHapusEvent extends Klaim1CrudEvents {
	final String recordId;
	const Klaim1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Klaim1CrudLihatEvent extends Klaim1CrudEvents {
	final String recordId;
	const Klaim1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends Klaim1CrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class ComboMStsclaimChangedEvent extends Klaim1CrudEvents{
	final ComboMStsclaimModel comboMStsclaim;
	const ComboMStsclaimChangedEvent({required this.comboMStsclaim});

	@override	List<Object> get props => [comboMStsclaim];}

