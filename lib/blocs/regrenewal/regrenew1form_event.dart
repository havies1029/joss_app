part of 'regrenew1form_bloc.dart';

abstract class Regrenew1FormEvents extends Equatable {
	const Regrenew1FormEvents();

	@override
	List<Object> get props => [];
}

class Regrenew1FormTambahEvent extends Regrenew1FormEvents {
	final Regrenew1FormModel record;
	const Regrenew1FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regrenew1FormUbahEvent extends Regrenew1FormEvents {
	final Regrenew1FormModel record;
	const Regrenew1FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regrenew1FormHapusEvent extends Regrenew1FormEvents {
	final String recordId;
	const Regrenew1FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regrenew1FormLihatEvent extends Regrenew1FormEvents {
	final String recordId;
	const Regrenew1FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

