part of 'regmv7form_bloc.dart';

abstract class Regmv7FormEvents extends Equatable {
	const Regmv7FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv7FormTambahEvent extends Regmv7FormEvents {
	final Regmv7FormModel record;
	const Regmv7FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv7FormUbahEvent extends Regmv7FormEvents {
	final Regmv7FormModel record;
	const Regmv7FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv7FormHapusEvent extends Regmv7FormEvents {
	final String recordId;
	const Regmv7FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv7FormLihatEvent extends Regmv7FormEvents {
	final String recordId;
	const Regmv7FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

