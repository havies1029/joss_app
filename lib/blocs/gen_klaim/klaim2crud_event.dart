part of 'klaim2crud_bloc.dart';

abstract class Klaim2CrudEvents extends Equatable {
	const Klaim2CrudEvents();

	@override
	List<Object> get props => [];
}

class Klaim2CrudTambahEvent extends Klaim2CrudEvents {
	final Klaim2CrudModel record;
	const Klaim2CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Klaim2CrudUbahEvent extends Klaim2CrudEvents {
	final Klaim2CrudModel record;
	const Klaim2CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Klaim2CrudHapusEvent extends Klaim2CrudEvents {
	final String recordId;
	const Klaim2CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Klaim2CrudLihatEvent extends Klaim2CrudEvents {
	final String recordId;
	const Klaim2CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMStsclaimChangedEvent extends Klaim2CrudEvents{
	final ComboMStsclaimModel comboMStsclaim;
	const ComboMStsclaimChangedEvent({required this.comboMStsclaim});

	@override	List<Object> get props => [comboMStsclaim];}

