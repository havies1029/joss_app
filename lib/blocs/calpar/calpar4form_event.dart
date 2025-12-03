part of 'calpar4form_bloc.dart';

abstract class Calpar4FormEvents extends Equatable {
	const Calpar4FormEvents();

	@override
	List<Object> get props => [];
}

class Calpar4FormTambahEvent extends Calpar4FormEvents {
	final Calpar4FormModel record;
	const Calpar4FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar4FormUbahEvent extends Calpar4FormEvents {
	final Calpar4FormModel record;
	const Calpar4FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar4FormHapusEvent extends Calpar4FormEvents {
	final String recordId;
	const Calpar4FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calpar4FormLihatEvent extends Calpar4FormEvents {
	final String recordId;
	const Calpar4FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calpar4FormHitungPremiEvent extends Calpar4FormEvents {
	final String calpar1Id;
	const Calpar4FormHitungPremiEvent({required this.calpar1Id});

	@override
	List<Object> get props => [calpar1Id];
}

