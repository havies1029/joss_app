part of 'regpar5form_bloc.dart';

abstract class Regpar5FormEvents extends Equatable {
	const Regpar5FormEvents();

	@override
	List<Object> get props => [];
}

class Regpar5FormTambahEvent extends Regpar5FormEvents {
	final Regpar5FormModel record;
	const Regpar5FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar5FormUbahEvent extends Regpar5FormEvents {
	final Regpar5FormModel record;
	const Regpar5FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar5FormHapusEvent extends Regpar5FormEvents {
	final String recordId;
	const Regpar5FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar5FormLihatEvent extends Regpar5FormEvents {
	final String recordId;
	const Regpar5FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar5FormHitungPremiEvent extends Regpar5FormEvents {
	final String recordId;
	const Regpar5FormHitungPremiEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}
