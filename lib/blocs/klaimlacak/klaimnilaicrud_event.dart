part of 'klaimnilaicrud_bloc.dart';

abstract class KlaimnilaicrudEvents extends Equatable {
	const KlaimnilaicrudEvents();

	@override
	List<Object> get props => [];
}

class KlaimnilaicrudTambahEvent extends KlaimnilaicrudEvents {
	final KlaimnilaicrudModel record;
	const KlaimnilaicrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimnilaicrudUbahEvent extends KlaimnilaicrudEvents {
	final KlaimnilaicrudModel record;
	const KlaimnilaicrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimnilaicrudHapusEvent extends KlaimnilaicrudEvents {
	final String recordId;
	const KlaimnilaicrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class KlaimnilaicrudLihatEvent extends KlaimnilaicrudEvents {
	final String recordId;
	const KlaimnilaicrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

