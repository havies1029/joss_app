part of 'regother2form_bloc.dart';

abstract class Regother2FormEvents extends Equatable {
	const Regother2FormEvents();

	@override
	List<Object> get props => [];
}

class Regother2FormTambahEvent extends Regother2FormEvents {
	final Regother2FormModel record;
	const Regother2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regother2FormUbahEvent extends Regother2FormEvents {
	final Regother2FormModel record;
	const Regother2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regother2FormHapusEvent extends Regother2FormEvents {
	final String recordId;
	const Regother2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regother2FormLihatEvent extends Regother2FormEvents {
	final String recordId;
	const Regother2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

