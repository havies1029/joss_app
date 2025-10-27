part of 'endors1crud_bloc.dart';

abstract class Endors1CrudEvents extends Equatable {
	const Endors1CrudEvents();

	@override
	List<Object> get props => [];
}

class Endors1CrudTambahEvent extends Endors1CrudEvents {
	final Endors1CrudModel record;
	const Endors1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Endors1CrudUbahEvent extends Endors1CrudEvents {
	final Endors1CrudModel record;
	const Endors1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Endors1CrudHapusEvent extends Endors1CrudEvents {
	final String recordId;
	const Endors1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Endors1CrudLihatEvent extends Endors1CrudEvents {
	final String recordId;
	const Endors1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

