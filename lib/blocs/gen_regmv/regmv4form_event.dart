part of 'regmv4form_bloc.dart';

abstract class Regmv4FormEvents extends Equatable {
	const Regmv4FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv4FormTambahEvent extends Regmv4FormEvents {
	final Regmv4FormModel record;
	const Regmv4FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv4FormUbahEvent extends Regmv4FormEvents {
	final Regmv4FormModel record;
	const Regmv4FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv4FormHapusEvent extends Regmv4FormEvents {
	final String recordId;
	const Regmv4FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv4FormLihatEvent extends Regmv4FormEvents {
	final String recordId;
	const Regmv4FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

