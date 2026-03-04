part of 'regpar6form_bloc.dart';

abstract class Regpar6FormEvents extends Equatable {
	const Regpar6FormEvents();

	@override
	List<Object> get props => [];
}

class Regpar6FormTambahEvent extends Regpar6FormEvents {
	final Regpar6FormModel record;
	const Regpar6FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar6FormUbahEvent extends Regpar6FormEvents {
	final Regpar6FormModel record;
	const Regpar6FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar6FormHapusEvent extends Regpar6FormEvents {
	final String recordId;
	const Regpar6FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar6FormLihatEvent extends Regpar6FormEvents {
	final String recordId;
	const Regpar6FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

