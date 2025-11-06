part of 'calmv2form_bloc.dart';

abstract class Calmv2FormEvents extends Equatable {
	const Calmv2FormEvents();

	@override
	List<Object> get props => [];
}

class Calmv2FormTambahEvent extends Calmv2FormEvents {
	final Calmv2FormModel record;
	const Calmv2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv2FormUbahEvent extends Calmv2FormEvents {
	final Calmv2FormModel record;
	const Calmv2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv2FormHapusEvent extends Calmv2FormEvents {
	final String recordId;
	const Calmv2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calmv2FormLihatEvent extends Calmv2FormEvents {
	final String recordId;
	const Calmv2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

