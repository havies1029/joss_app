part of 'regmv1crud_bloc.dart';

abstract class Regmv1CrudEvents extends Equatable {
	const Regmv1CrudEvents();

	@override
	List<Object> get props => [];
}

class Regmv1CrudTambahEvent extends Regmv1CrudEvents {
	final Regmv1CrudModel record;
	const Regmv1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv1CrudUbahEvent extends Regmv1CrudEvents {
	final Regmv1CrudModel record;
	const Regmv1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv1CrudHapusEvent extends Regmv1CrudEvents {
	final String recordId;
	const Regmv1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv1CrudLihatEvent extends Regmv1CrudEvents {
	final String recordId;
	const Regmv1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv1DraftEvent extends Regmv1CrudEvents {
	final Regmv1CrudModel record;
	const Regmv1DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

