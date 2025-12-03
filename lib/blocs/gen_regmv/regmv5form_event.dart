part of 'regmv5form_bloc.dart';

abstract class Regmv5FormEvents extends Equatable {
	const Regmv5FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv5FormTambahEvent extends Regmv5FormEvents {
	final Regmv5FormModel record;
	const Regmv5FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv5FormUbahEvent extends Regmv5FormEvents {
	final Regmv5FormModel record;
	const Regmv5FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv5FormHapusEvent extends Regmv5FormEvents {
	final String recordId;
	const Regmv5FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv5FormLihatEvent extends Regmv5FormEvents {
	final String recordId;
	const Regmv5FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

