part of 'regpar1crud_bloc.dart';

abstract class Regpar1CrudEvents extends Equatable {
	const Regpar1CrudEvents();

	@override
	List<Object> get props => [];
}

class Regpar1CrudTambahEvent extends Regpar1CrudEvents {
	final Regpar1CrudModel record;
	const Regpar1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar1CrudUbahEvent extends Regpar1CrudEvents {
	final Regpar1CrudModel record;
	const Regpar1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar1CrudHapusEvent extends Regpar1CrudEvents {
	final String recordId;
	const Regpar1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar1CrudLihatEvent extends Regpar1CrudEvents {
	final String recordId;
	const Regpar1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

