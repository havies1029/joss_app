part of 'regendors1form_bloc.dart';

abstract class Regendors1FormEvents extends Equatable {
	const Regendors1FormEvents();

	@override
	List<Object> get props => [];
}

class Regendors1FormTambahEvent extends Regendors1FormEvents {
	final Regendors1FormModel record;
	const Regendors1FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regendors1FormUbahEvent extends Regendors1FormEvents {
	final Regendors1FormModel record;
	const Regendors1FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regendors1FormHapusEvent extends Regendors1FormEvents {
	final String recordId;
	const Regendors1FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regendors1FormLihatEvent extends Regendors1FormEvents {
	final String recordId;
	const Regendors1FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

